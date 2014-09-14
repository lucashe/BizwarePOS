class SalesController < ApplicationController
  def index
    if current_user.is? :superadmin
      @sales = Sale.all.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    elsif current_user.is? :storeadmin
      @sales = @current_store.sales.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    elsif current_user.is? :branchadmin
      @sales = @current_branch.sales.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    elsif current_user.is? :straff
      @sales = current_user.sales.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    end
  end

  def new
    @sale = @current_branch.sales.create(:user_id => current_user.id)
    redirect_to :controller => 'sales', :action => 'edit', :id => @sale.id
  end

  def edit
    set_sale

    get_popular_items
    populate_items

    @sale.line_items.build
    @sale.payments.build

    @custom_item = @current_store.items.new
    @custom_customer = @current_store.customers.new

  end

  def show
    set_sale
  end

  def destroy
    set_sale

    if current_user.can_update_items == true
    @sale.destroy
    else
      redirect_to @sale, notice: 'You do not have permission to delete sales.'
    end
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale has been deleted.'}
      format.json { head :no_content }
    end
  end

  # searched Items
  def update_line_item_options
    set_sale
    populate_items

    if params[:search].blank?
      @available_items = @current_store.items.where('published = true').paginate(:page => params[:page], :per_page => 20)
    else
      if params[:search][:item_category].blank?
        # Search by item name
        @available_items = @current_store.items.where('name ILIKE ? AND published = true OR description ILIKE ? AND published = true OR sku ILIKE ? AND published = true', "%#{params[:search][:item_name]}%", "%#{params[:search][:item_name]}%", "%#{params[:search][:item_name]}%").paginate(:page => params[:page], :per_page => 20)
      elsif params[:search][:item_name].blank?
        # Search by item category
        if params[:search][:item_category].to_s == '-1'
          # Show all
          @available_items = @current_store.items.where('published = true').paginate(:page => params[:page], :per_page => 20)
        else
        # Show specific category
          @available_items = @current_store.items.where('item_category_id = ? AND published = true', "#{params[:search][:item_category]}").paginate(:page => params[:page], :per_page => 20)
        end
      else
      # Search by both
        @available_items = @current_store.items.where('name ILIKE ? AND published = true AND item_category_id = ? OR description ILIKE ? AND published = true AND item_category_id = ? OR sku ILIKE ? AND published = true AND item_category_id = ?', "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}", "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}", "%#{params[:search][:item_name]}%", "#{params[:search][:item_category]}").paginate(:page => params[:page], :per_page => 20)
      end

    end

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def update_customer_options
    set_sale
    populate_items

    @available_customers = @current_store.customers.find(:all, :conditions => ['last_name ILIKE ? AND published = true OR first_name ILIKE ? AND published = true OR email_address ILIKE ? AND published = true OR phone_number ILIKE ? AND published = true OR IC ILIKE ? AND published = true', "%#{params[:search][:customer_name]}%","%#{params[:search][:customer_name]}%", "%#{params[:search][:customer_name]}%", "%#{params[:search][:customer_name]}%", "%#{params[:search][:customer_name]}%"], :limit => 5)

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def create_customer_association
    set_sale
    populate_items

    unless @sale.blank? || params[:customer_id].blank?
      @sale.customer_id = params[:customer_id]
    @sale.discount = @current_store.member_discount.to_d/100
    @sale.save
    end

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Add a searched Item
  def create_line_item

    set_sale
    populate_items

    existing_line_item = LineItem.where("item_id = ? AND sale_id = ?", params[:item_id], @sale.id).first

    if existing_line_item.blank?
      line_item = LineItem.new(:item_id => params[:item_id], :sale_id => params[:sale_id], :quantity => params[:quantity])
      line_item.price = line_item.item.price
      line_item.cost  = line_item.item.cost_price
      line_item.save

      remove_item_from_stock(params[:item_id], 1, params[:branch_id])
      update_line_item_totals(line_item)
    else

    existing_line_item.quantity += 1
      existing_line_item.save

      remove_item_from_stock(params[:item_id], 1, params[:branch_id])
      update_line_item_totals(existing_line_item)
    end

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Remove Item
  def remove_item
    set_sale
    populate_items

    line_item = LineItem.where(:sale_id => params[:sale_id], :item_id => params[:item_id]).first
    line_item.quantity -= 1
    if line_item.quantity <= 0
      line_item.destroy
    else
      line_item.save
      update_line_item_totals(line_item)
    end

    return_item_to_stock(params[:item_id], 1, params[:branch_id])

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Add one Item
  def add_item
    set_sale
    populate_items

    line_item = LineItem.where(:sale_id => params[:sale_id], :item_id => params[:item_id]).first
    line_item.quantity += 1
    line_item.save

    remove_item_from_stock(params[:item_id], 1, params[:branch_id])
    update_line_item_totals(line_item)

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def remove_all_item

    set_sale
    populate_items
    
    
  end

  def create_custom_item
    set_sale
    populate_items

    custom_item = Item.new
    custom_item.sku = "CI#{(rand(5..30) + rand(5..30)) * 11}_#{(rand(5..30) + rand(5..30)) * 11}"
    custom_item.name = params[:custom_item][:name]
    custom_item.description = params[:custom_item][:description]
    custom_item.price = params[:custom_item][:price]
    custom_item.stock_amount = params[:custom_item][:stock_amount]
    custom_item.item_category_id = params[:custom_item][:item_category_id]

    custom_item.save

    custom_line_item = LineItem.new(:item_id => custom_item.id, :sale_id => @sale.id, :quantity => custom_item.stock_amount, :price => custom_item.price )
    custom_line_item.total_price = custom_item.price * custom_item.stock_amount
    custom_line_item.save

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  def create_custom_customer
    set_sale
    populate_items

    custom_customer = @current_store.customers.new
    custom_customer.first_name = params[:custom_customer][:first_name]
    custom_customer.last_name = params[:custom_customer][:last_name]
    custom_customer.email_address = params[:custom_customer][:email_address]
    custom_customer.phone_number = params[:custom_customer][:phone_number]
    custom_customer.address = params[:custom_customer][:address]
    custom_customer.city = params[:custom_customer][:city]
    custom_customer.state = params[:custom_customer][:state]
    custom_customer.zip = params[:custom_customer][:zip]

    custom_customer.save

    @sale.add_customer(custom_customer.id)

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # Update Price For one Line Item
  def override_price

    populate_items

    @sale = Sale.find(params[:override_price][:sale_id])

    item = Item.where(:id => params[:override_price][:line_item_id] ).first
    line_item = LineItem.where(:sale_id => params[:override_price][:sale_id], :item_id => item.id).first
    line_item.price = params[:override_price][:price].gsub('$', '')
    line_item.save

    update_line_item_totals(line_item)
    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  # update Total Price/Cost For Line Items
  def update_line_item_totals(line_item)
    line_item.total_price = line_item.price * line_item.quantity
    line_item.total_cost = line_item.cost * line_item.quantity

    line_item.save
  end

  # Update Total Discount
  def sale_discount

    populate_items

    @sale = Sale.find(params[:sale_discount][:sale_id])
    @sale.discount = params[:sale_discount][:discount]
    @sale.save

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end

  end

  def rewards_redemption

    populate_items

    @sale = Sale.find(params[:sale_reward][:sale_id])
    @use_rewards = params[:sale_reward][:use_rewards]

    if @use_rewards == 'true'
      @sale.rewards_used = [@sale.customer.rewards, @sale.total_amount].min
    else
    @sale.rewards_used = 0
    end
    @sale.save

    update_totals

    respond_to do |format|
      format.js { ajax_refresh }
    end

  end

  # Destroy Line Item
  # def destroy_line_item
  #
  # set_sale
  #
  # update_totals
  #
  # respond_to do |format|
  # format.js { ajax_refresh }
  # end
  # end

  # Update Sale Totals
  def update_totals

    tax_rate = get_tax_rate
    reward_rate = get_reward_rate

    set_sale

    @sale.amount = 0.00
    @sale.cost   = 0.00

    for line_item in @sale.line_items
      @sale.amount += line_item.total_price
      @sale.cost   += line_item.total_cost
    end

    @sale.tax = @sale.amount * tax_rate

    total_amount = @sale.amount
    #total_amount = @sale.amount + (@sale.amount * tax_rate

    if @sale.discount.blank?
    @sale.total_amount = total_amount
    else
    discount_amount = total_amount * @sale.discount
    @sale.total_amount = total_amount - discount_amount
    end

    @sale.total_amount = @sale.total_amount - @sale.rewards_used

    if not @sale.customer.blank?
    @sale.rewards_earned = @sale.total_amount * reward_rate
    end

    @sale.save
  end

  def add_comment

    set_sale
    populate_items

    @sale.comments = params[:sale_comments][:comments]
    @sale.save

    respond_to do |format|
      format.js { ajax_refresh }
    end
  end

  private

  def ajax_refresh
    return render(:file => 'sales/ajax_reload.js.erb')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    if @sale.blank?
      if params[:sale_id].blank?
        if params[:search].blank?
          @sale = Sale.find(params[:id])
        else
          @sale = Sale.find(params[:search][:sale_id])
        end
      else
        @sale = Sale.find(params[:sale_id])
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sale_params
    params.require(:sale).permit(:amount, :tax, :discount, :total_amount, :tax_paid, :amount_paid, :paid, :payment_type_id, :customer_id, :comments, :line_items_attributes, :items_attributes)
  end

  def populate_items
    @available_items = @current_store.items.where('published = true').paginate(:page => params[:page], :per_page => 20)
  end

  def populate_customers
    # @available_customers = @current_store.customers.all(:conditions => ['published', true], :limit => 5)
  end

  def remove_item_from_stock(item_id, quantity, branch_id)
    item = Item.find(item_id)
    @bi =  item.branch_items.where(:branch_id => branch_id).first
    @bi.stock_amount-= quantity
    @bi.amount_sold += quantity
    @bi.save
  end

  def return_item_to_stock(item_id, quantity, branch_id)
    item = Item.find(item_id)
    @bi =  item.branch_items.where(:branch_id => branch_id).first
    @bi.stock_amount+= quantity
    @bi.amount_sold -= quantity
    @bi.save
  end

  def get_tax_rate
    if @current_store.tax_rate.blank?
    return 0.07
    else
    return @current_store.tax_rate.to_f * 0.01
    end
  end

  def get_reward_rate
    if @current_store.member_reward.blank?
    return 0
    else
    return @current_store.member_reward.to_f * 0.01
    end
  end

  def get_popular_items
    if current_user.is? :superadmin
      elsif current_user.is? :storeadmin
        @popular_items = @current_store.items.joins(:branch_items).select("item_id as id,name,sum(stock_amount) as stock_amount,sum(amount_sold) as amount_sold").group("name,item_id").find(:all, :limit => 10, :order => 'amount_sold DESC')
      elsif current_user.is? :branchadmin
        @popular_items = @current_branch.items.joins(:branch_items).select("item_id as id,name,sum(stock_amount) as stock_amount,sum(amount_sold) as amount_sold").group("name,item_id").find(:all, :limit => 10, :order => 'amount_sold DESC')
      elsif current_user.is? :staff
      end
  end

end

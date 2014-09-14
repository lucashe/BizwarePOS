class DashboardController < ApplicationController
  def index

    #@recent_sales = Sale.find(:all, :limit => 10, :order => 'id DESC')
    #@popular_items = Item.find(:all, :limit => 10, :order => 'amount_sold DESC')
    prepare_data

  end

  def switch_branch
    @current_branch_id = params[:switch_branch_to]
    session[:current_branch_id] = @current_branch_id
    @current_branch = Branch.find(@current_branch_id)

    # Go to dashboard
    prepare_data
    render 'index'
  end

  def create_sale_with_product
    @sale = @current_branch.sales.create(:user_id => current_user.id)
    item = Item.find(params[:item_id])
    LineItem.create(:item_id => params[:item_id].to_i, :quantity => params[:quantity].to_i, :price => item.price, :total_price => item.price * params[:quantity].to_i, :cost => item.cost_price, :total_cost => item.cost_price * params[:quantity].to_i, :sale_id => @sale.id)

    price = (item.price * params[:quantity].to_i)

    @sale.tax = price * get_tax_rate
    @sale.amount = price
    #@sale.total_amount = price + (price * get_tax_rate)
    @sale.total_amount = price
    @sale.save

    redirect_to :controller => 'sales', :action => 'edit', :id => @sale.id
  end

  def get_tax_rate
    if @current_store.tax_rate.blank?
    return 0.07
    else
    return @current_store.tax_rate.to_f * 0.01
    end
  end

  private

  def prepare_data

    if current_user.is? :superadmin
      elsif current_user.is? :storeadmin
        @recent_sales = @current_store.sales.find(:all, :limit => 10, :order => 'id DESC')
        @popular_items = @current_store.items.joins(:branch_items).select("item_id as id,name,sum(stock_amount) as stock_amount,sum(amount_sold) as amount_sold").group("name,item_id").find(:all, :limit => 10, :order => 'amount_sold DESC')
      elsif current_user.is? :branchadmin
        @recent_sales = @current_branch.sales.find(:all, :limit => 10, :order => 'id DESC')
        @popular_items = @current_branch.items.joins(:branch_items).select("item_id as id,name,sum(stock_amount) as stock_amount,sum(amount_sold) as amount_sold").group("name,item_id").find(:all, :limit => 10, :order => 'amount_sold DESC')
      elsif current_user.is? :staff

      end
  end

end

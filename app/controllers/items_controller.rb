class ItemsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:new, :create]

  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  # GET /items
  # GET /items.json
  def index
    authorize! :index, Item
    
     #@filterrific = Filterrific.new(Item, params[:filterrific] || session[:filterrific_items] )
     @filterrific = Filterrific.new(Item, params[:filterrific])
     @items = Item.filterrific_find(@filterrific).where("store_id = ? AND published = true", @current_store_id).page(params[:page]).per(10)
     
     #session[:filterrific_items] = @filterrific.to_hash
     respond_to do |format|
      format.html
      format.js
     end
    
    #@items = @current_store.items.paginate(:page => params[:page], :per_page => 20).where(:published => true)
  end
  
  def reset_filterrific
    #session[:filterrific_items] = nil
    redirect_to :action => :index
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    for b in @current_store.branches
      @item.branch_items.build(:branch_id => b.id,:stock_amount => 0)
    end

  end

  # GET /items/1/edit
  def edit

  end

  # POST /items
  # POST /items.json
  def create

    @item = @current_store.items.build(item_params)
    @item.published = true
    @item.generate_sku
    
    qr_code_img = RQRCode::QRCode.new(@item.sku, :size => 4, :level => :m).to_img.resize(200, 200)
    @item.qr_code = qr_code_img.to_string

    respond_to do |format|
      if @item.save        
        format.html { redirect_to items_path, notice: 'Item was successfully created.' }
        format.json { render action: 'show', status: :created, location: @item }
      else
        format.html { render action: 'new' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update

    respond_to do |format|
      
      # Generate SKU if blank
      if @item.sku.blank?
        @item.generate_sku
        qr_code_img = RQRCode::QRCode.new(@item.sku, :size => 4, :level => :m).to_img.resize(200, 200)
        @item.qr_code = qr_code_img.to_string
        if not @item.save
           format.html { render action: 'edit' }
           format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
      
      if @item.update(item_params)
        format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.published = false
    @item.save

    respond_to do |format|
      format.html { redirect_to items_path }
      format.json { head :no_content }
    end
  end

  def search
    # @items =  Item.where(["name LIKE :tag", {:tag => params[:search][:item_name]}])
    @items =  Item.find(:all, :conditions => ['name LIKE ?', "%#{params[:search][:item_name]}%"])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
    #@categories = @current_store.item_categories.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:image, :image_cache,:name, :description, :price, :cost_price, :item_category_id, :published, branch_items_attributes: [:id,:branch_id,:stock_amount])
  end
end

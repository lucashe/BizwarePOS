class StoresController < ApplicationController

  load_and_authorize_resource

  before_action :set_store, only: [:show, :edit, :update, :destroy]
  def index

    authorize! :index, Store

    if current_user.is?(:superadmin)
      @stores = Store.all.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    end

  end

  def show

  end

  def new
    @store = Store.new
  end

  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url }
      format.json { head :no_content }
    end
  end

  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render action: 'show', status: :created, location: @store }
      else
        format.html { render action: 'new' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    authorize! :update, @store

    respond_to do |format|
      if @store.update(store_params)

        if(current_user.is? :superadmin)
          format.html { redirect_to '/stores', notice: 'Store has been successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to edit_store_path(@store), notice: 'Store has been successfully updated.' }
          format.json { head :no_content }
        end

      else
        format.html { render controller: 'stores' }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:store).permit(:store_name, :store_description,:currency, :tax_rate)
  end

  def set_store
    @store = Store.find(params[:id])
  end

end

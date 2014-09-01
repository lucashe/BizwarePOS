class StoreBranchesController < ApplicationController
  before_action :set_store_branch, only: [:show, :edit, :update, :destroy]
  # GET /store_branches
  # GET /store_branches.json
  def index
    if current_user.is?(:superadmin)
      @store_branches = StoreBranch.all.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    else
      @store_branches = @current_store.store_branches.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    end

    authorize! :index, StoreBranch

  end

  # GET /store_branches/1
  # GET /store_branches/1.json
  def show
  end

  # GET /store_branches/new
  def new
    @store_branch = StoreBranch.new
  end

  # GET /store_branches/1/edit
  def edit
  end

  # POST /store_branches
  # POST /store_branches.json
  def create

    @store_branch = StoreBranch.new(store_branch_params)

    respond_to do |format|
      if @store_branch.save
        format.html { redirect_to @store_branch, notice: 'Store branch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @store_branch }
      else
        format.html { render action: 'new' }
        format.json { render json: @store_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /store_branches/1
  # PATCH/PUT /store_branches/1.json
  def update

    authorize! :update, StoreBranch

    respond_to do |format|
      if @store_branch.update(store_branch_params)
        format.html { redirect_to store_branches_path, notice: 'Store branch was successfully updated.' }
        format.json { head :no_content}
      else
        format.html { render action: 'edit' }
        format.json { render json: @store_branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_branches/1
  # DELETE /store_branches/1.json
  def destroy
    @store_branch.destroy
    respond_to do |format|
      format.html { redirect_to store_branches_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_store_branch
    @store_branch = StoreBranch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_branch_params
    params[:store_branch].permit(:store_id,:branch_name,:branch_description,:email_address,:phone_number,:website_url,:addr_floor,:addr_unit,:addr_block,:addr_street,:addr_building,:city,:state,:zip, user_ids: [])
  end

end

class BranchesController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]
  # GET /branches
  # GET /branches.json
  def index
    if current_user.is?(:superadmin)
      @branches = Branch.all.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    else
      @branches = @current_store.branches.paginate(:page => params[:page], :per_page => 20, :order => 'id DESC')
    end

    authorize! :index, Branch

  end

  # GET /branches/1
  # GET /branches/1.json
  def show
  end

  # GET /branches/new
  def new
    @branch = Branch.new
    
    if not params[:preset_store_id].nil?
      @branch.store_id = params[:preset_store_id]
    end
  end

  # GET /branches/1/edit
  def edit
  end

  # POST /branches
  # POST /branches.json
  def create

    @branch = Branch.new(branch_params)

    respond_to do |format|
      if @branch.save
        format.html { redirect_to @branch, notice: 'Store branch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @branch }
      else
        format.html { render action: 'new' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /branches/1
  # PATCH/PUT /branches/1.json
  def update

    authorize! :update, Branch

    respond_to do |format|
      if @branch.update(branch_params)
        format.html { redirect_to branches_path, notice: 'Store branch was successfully updated.' }
        format.json { head :no_content}
      else
        format.html { render action: 'edit' }
        format.json { render json: @branch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @branch.destroy
    respond_to do |format|
      format.html { redirect_to branches_url }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_branch
    @branch = Branch.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def branch_params
    params[:branch].permit(:store_id,:branch_name,:branch_description,:email_address,:phone_number,:website_url,:addr_floor,:addr_unit,:addr_block,:addr_street,:addr_building,:city,:state,:zip, user_ids: [])
  end

end

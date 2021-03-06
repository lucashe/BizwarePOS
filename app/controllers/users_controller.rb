class UsersController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource :only => [:new, :create]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.json
  def index
    authorize! :index, User

    if current_user.is?(:superadmin)
      @users = User.page(params[:page]).per(20)
    else
      @users = @current_store.users.page(params[:page]).per(20)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def new_store_admin
    @user = User.new
    @user.role = :storeadmin
  end

  def new_branch_admin
    @user = User.new
    @user.role = :branchadmin
  end

  def new_staff
    @user = User.new
    @user.role = :staff
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
  end

  def new_user
    if current_user.is? :superadmin
      @user = User.new(user_params)
    else
      @user = @current_store.users.build(user_params)
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'user was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_store_select
    @branches_select = Branch.where(:store_id => params[:store_select_id])
    render :partial => "branch"
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if user_params[:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    respond_to do |format|

      if @user.update(user_params)

        # Prevent user to be logged out after update
        # sign_in(@user, :bypass => true)

        format.html { redirect_to users_path, notice: 'user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private

  def ajax_refresh
    return render(:file => 'users/ajax_reload_branches.js.erb')
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:store_id, :email, :username, :password, :password_confirmation, :remember_me, :can_update_users, :can_update_items, :can_update_configuration, :can_view_reports, :can_update_sale_discount, :can_remove_sales, :role, branch_ids: [] )
  end
end

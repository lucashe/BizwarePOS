class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  before_filter :authenticate_user!
  before_filter :set_current_store
  before_filter :set_current_branch

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def set_current_store

    return if not user_signed_in?
    return if current_user.is? :superadmin

    @current_store_id = session[:current_store_id]

    if @current_store_id.nil?
      @current_store_id = current_user.store.id
      session[:current_store_id] = @current_store_id
    end

    @current_store = Store.find(@current_store_id)

  end

  def set_current_branch

    return if not user_signed_in?
    return if current_user.is? :superadmin

    @current_branch_id = session[:current_branch_id]

    if @current_branch_id.nil?
      @current_branch_id = current_user.branches.first.id
      session[:current_branch_id] = @current_branch_id
    end

    @current_branch = Branch.find(@current_branch_id)

  end

  def set_locale
    if current_user.nil?
      I18n.locale = params[:locale] || I18n.default_locale
    else
      I18n.locale = current_user.locale || params[:locale] || I18n.default_locale
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

end

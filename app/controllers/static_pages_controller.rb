class StaticPagesController < ApplicationController

  skip_before_filter :authenticate_user!
  skip_before_filter :set_current_store
  skip_before_filter :set_current_branch

  layout "home"
  
  def home
    
    @stores = Store.all

  end
  
  def shop
    
  end

  def help
  end

  def about
  end

  def contact
  end

end

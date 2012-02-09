class PagesController < ApplicationController
  
  before_filter :make_login, :ignore => :users
  
  def make_login
    if !anyone_signed_in? 
      deny_access
    end
  end
  
  def amb
    @users = User.all
  end
end

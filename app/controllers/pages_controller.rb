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
  
  def bb
    @user = current_user
  end
  
  def send_to_buyer
    
    user = User.find(params['id'])
    jewels = user.jewels.select{ |j| j['status'] == 0 }
    
    jewels.each do |j|
      j.status = 1
      j.save()
    end
    
    render :json => { :success => true }
  end
  
  def submit_by_buyer
    user = User.find(params['id'])
    jewels = user.jewels.select{ |j| j['status'] == 1 }
    
    jewels.each do |j|
      j.status = 2
      j.save()
    end
    
    render :json => { :success => true }
  end
end

require 'erb'
class PagesController < ApplicationController
  
  before_filter :make_login, :ignore => :users
  
  def make_login
    if !anyone_signed_in? 
      deny_access
    end
  end
  
  def amb
    if !current_user.is_admin
      redirect_to :action => 'bb'
    end
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
#    puts "Submit by buyer params: " + params.to_json
    user = User.find(params['id'])
    
    if (user.nil?)
      render :json => { :success => false }
      return
    end
    
    jewel_items = params['jewels']
    jewel_items.each do |item|
      found_jewel = user.jewels.select{ |j| j['status'] == 1 && j['id'].to_s == item['id'] }.first()
      unless found_jewel.nil?
        found_jewel.status = item['approved'] ? 3 : 2
        found_jewel.save
      end
    end
    
    render :json => { :success => true }
  end
  
  def send_comment
    jewel = Jewel.find(params['id'])
    
    if params['comment'].blank?
      render :json => { :success => false, :msg => 'Empty text of comment' }
      return
    end
    
    new_comment_params = {
      :comment => params['comment'],
      :user_id => current_user.id
    }
    
    comment = jewel.comments.create!(new_comment_params)
    simple_template = open(File.join(Rails.root, 'app/views/shared/_item_comment.html.erb')).read
    template = ERB.new(simple_template)
    html = template.result(binding)
        
    render :json => { :success => true, :data => html }
    
  end
  
end

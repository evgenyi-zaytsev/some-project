class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :shade_symbols
  
  def deny_access
    store_location
    redirect_to new_user_session_path
  end

  # add back anyone_signed_in? method after Oliver's comment @ 2011-03-12
  def anyone_signed_in?
    !current_user.nil?
  end

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      clear_stored_location
      (store_location.nil?) ? "/" : store_location.to_s
    else
      super
    end
  end
  
  def shade_symbols
    unless params["action"] == "file_upload"
      filter_params = params.to_hash
      filter_params.each_pair do |index, prm|

		    filter_params[index] = shade_item(prm)
      end
      params.merge!(ApplicationController.shade_symbols(filter_params))
    end
  end
  
  def shade_item(prm)
    result = prm
    if prm.is_a?(String) && !prm.blank?
      return prm unless prm.match(/^\s*[\[\{]+\s*.*\s*[\}\]]+\s*$/)
      begin
        result = ActiveSupport::JSON.decode(prm)
      rescue
        result = prm
      end
    else
      if prm.respond_to?('each_pair')
        result = {}
        prm.each_pair do |inner_index, inner_prm|
           result[inner_index] = shade_item(inner_prm)
        end
      end
    end

		return result
  end
  
  def self.shade_symbols(obj, level=nil)
    obj = obj.to_s if obj.class.name == "Date"
    case (obj.class.name)
    when "Array"
      result = []
      obj.each {|value| result << self.shade_symbols(value, level) }

    when "Hash", "ActiveSupport::HashWithIndifferentAccess"
      result = {}
      obj.each_pair {|key, value| result[key] = self.shade_symbols(value, level) }

    when "String"
      result = obj.blank? ? obj : obj.to_s.dump.gsub("'", "\\\\'").sub(/^\"/, '').sub(/\"$/, '')
      result = result.gsub(/\\u\{[\w\d]+\}/){|x| [x.match("\\\\u\{([\\w\\d]+\)}")[1].hex].pack("U*")}

    else # if obj is NOT a STRING, HASH or ARRAY
      result = obj
    end
    return result
	end
  
  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_stored_location
    session[:return_to] = nil
  end

end

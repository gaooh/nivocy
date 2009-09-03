class <%= controller_class_name %>Controller < ApplicationController
  # Be sure to include DrecomLdapLoginSystem in Application Controller instead
  include DrecomLdapLoginSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  #before_filter :login_from_cookie

  def index
    redirect_to(:action => 'login') unless logged_in?
  end

  def login
    return unless request.post?
    self.current_<%= file_name %> = authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_<%= file_name %>.remember_me
        cookies[:auth_token] = { :value => self.current_<%= file_name %>.remember_token , :expires => self.current_<%= file_name %>.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Logged in failure"
    end
  end

  
  def logout
    self.current_<%= file_name %>.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/<%= controller_file_name %>', :action => 'index')
  end
end

require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase
  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_login_true
    @request.session[:from] = "/home/index"
    post :login, :user => { :office_id => 'asami', :passwd => 'sabosabo1022'}
    assert_response :redirect
  end
  
  def test_login_false
    post :login, :user => { :office_id => 'asami', :passwd => 'sabosabo'}
    assert_response :success
    assert_template 'signin'
  end
end

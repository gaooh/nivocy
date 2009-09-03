require File.dirname(__FILE__) + '/../test_helper'
require 'daccount_controller'

# Re-raise errors caught by the controller.
class DaccountController; def rescue_action(e) raise e end; end

class DaccountControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include DrecomLdapLoginTestHelper

  fixtures :dusers

  def setup
    @controller = DaccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_login_and_redirect
    post :login, :login => 'arai_motoki', :password => '********'
    assert session[:duser]
    assert_response :redirect
  end

  def test_should_fail_login_and_not_redirect
    post :login, :login => 'arai_motoki', :password => 'bad password'
    assert_nil session[:duser]
    assert_response :success
  end

  def test_should_allow_signup
    assert_difference Duser, :count do
      create_duser
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference Duser, :count do
      create_duser(:login => nil)
      assert assigns(:duser).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference Duser, :count do
      create_duser(:password => nil)
      assert assigns(:duser).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference Duser, :count do
      create_duser(:password_confirmation => nil)
      assert assigns(:duser).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference Duser, :count do
      create_duser(:email => nil)
      assert assigns(:duser).errors.on(:email)
      assert_response :success
    end
  end

  def test_should_logout
    login_as :arai_motoki
    get :logout
    assert_nil session[:duser]
    assert_response :redirect
  end

  def test_should_remember_me
    post :login, :login => 'arai_motoki', :password => '********', :remember_me => "1"
    assert_not_nil @response.cookies["auth_token"]
  end

  def test_should_not_remember_me
    post :login, :login => 'arai_motoki', :password => '********', :remember_me => "0"
    assert_nil @response.cookies["auth_token"]
  end
  
  def test_should_delete_token_on_logout
    login_as :arai_motoki
    get :logout
    assert_equal @response.cookies["auth_token"], []
  end

  def test_should_login_with_cookie
    dusers(:arai_motoki).remember_me
    @request.cookies["auth_token"] = cookie_for(:arai_motoki)
    get :index
    assert @controller.send(:logged_in?)
  end

  def test_should_fail_expired_cookie_login
    dusers(:arai_motoki).remember_me
    users(:arai_motoki).update_attribute :remember_token_expires_at, 5.minutes.ago
    @request.cookies["auth_token"] = cookie_for(:arai_motoki)
    get :index
    assert !@controller.send(:logged_in?)
  end

  def test_should_fail_cookie_login
    dusers(:arai_motoki).remember_me
    @request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :index
    assert !@controller.send(:logged_in?)
  end

  protected
    def create_duser(options = {})
      post :signup, :duser => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(duser)
      auth_token dusers(duser).remember_token
    end
end

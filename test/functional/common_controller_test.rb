require File.dirname(__FILE__) + '/../test_helper'
require 'common_controller'

# Re-raise errors caught by the controller.
class CommonController; def rescue_action(e) raise e end; end

class CommonControllerTest < Test::Unit::TestCase
  def setup
    @controller = CommonController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

require File.dirname(__FILE__) + '/../test_helper'
require 'ideas_controller'

# Re-raise errors caught by the controller.
class IdeasController; def rescue_action(e) raise e end; end

class IdeasControllerTest < Test::Unit::TestCase
  def setup
    @controller = IdeasController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

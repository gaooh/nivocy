require File.dirname(__FILE__) + '/../test_helper'
require 'wikis_controller'

# Re-raise errors caught by the controller.
class WikisController; def rescue_action(e) raise e end; end

class WikisControllerTest < Test::Unit::TestCase
  def setup
    @controller = WikisController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

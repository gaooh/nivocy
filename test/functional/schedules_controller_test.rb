require File.dirname(__FILE__) + '/../test_helper'
require 'schedules_controller'

# Re-raise errors caught by the controller.
class SchedulesController; def rescue_action(e) raise e end; end

class SchedulesControllerTest < Test::Unit::TestCase
  def setup
    @controller = SchedulesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

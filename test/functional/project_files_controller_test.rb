require File.dirname(__FILE__) + '/../test_helper'
require 'project_files_controller'

# Re-raise errors caught by the controller.
class ProjectFilesController; def rescue_action(e) raise e end; end

class ProjectFilesControllerTest < Test::Unit::TestCase
  def setup
    @controller = ProjectFilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

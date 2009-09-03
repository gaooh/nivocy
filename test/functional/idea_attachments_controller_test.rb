require File.dirname(__FILE__) + '/../test_helper'
require 'idea_attachments_controller'

# Re-raise errors caught by the controller.
class IdeaAttachmentsController; def rescue_action(e) raise e end; end

class IdeaAttachmentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = IdeaAttachmentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

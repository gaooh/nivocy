require File.dirname(__FILE__) + '/../test_helper'
require 'task_logs_controller'

# Re-raise errors caught by the controller.
class TaskLogsController; def rescue_action(e) raise e end; end

class TaskLogsControllerTest < Test::Unit::TestCase
  fixtures :task_logs

  def setup
    @controller = TaskLogsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = task_logs(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:task_logs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:task_log)
    assert assigns(:task_log).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:task_log)
  end

  def test_create
    num_task_logs = TaskLog.count

    post :create, :task_log => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_task_logs + 1, TaskLog.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:task_log)
    assert assigns(:task_log).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      TaskLog.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      TaskLog.find(@first_id)
    }
  end
end

class TaskLogsController < ApplicationController
  before_filter :signin_filter
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @task_log_pages, @task_logs = paginate :task_logs, :per_page => 10
  end

  def show
    @task_log = TaskLog.find(params[:id])
  end

  def new
    @task_log = TaskLog.new
  end

  def ajax_create
    @task_log = TaskLog.new(params[:task_log])
    @task_log.change_user_id = _user_id
    
    message_buf = ""
    task = Task.find(@task_log.task_id)
    new_task = Task.new(params[:task])
    new_task.goal_at = Util.parse_by_day_time(params[:task_goal])
    new_task.id = task.id
    new_task.create_user_id = _user_id
    
    if task.milestone_id != new_task.milestone_id
      message_buf << log_message('マイルストーン', task.milestone.name, new_task.milestone.name)
      task.milestone_id = new_task.milestone_id
    end
    
    if task.treat_user_id != new_task.treat_user_id
      message_buf << log_message('担当者', task.treat_user.office_id, new_task.treat_user.office_id)
      task.treat_user_id = new_task.treat_user_id
    end
    
    if task.status_id != new_task.status_id
      message_buf << log_message('状態', task.status.name, new_task.status.name)
      task.status_id = new_task.status_id
    end
    
    if task.goal_at != new_task.goal_at
      message_buf << log_message('完了予定日', task.goal_at.strftime("%Y/%m/%d　%M:%M"), new_task.goal_at.strftime("%Y/%m/%d　%M:%M")) 
      task.goal_at = new_task.goal_at
    end
    
    if new_task.completion?
      task.complete_at = Time.now
    end
    
    @task_log.message = message_buf + @task_log.message
    begin 
      Task.transaction(@task_log, task) do
        @task_log.save
        task.update
      end
      @index = TaskLog.count_task_log(task.id)
      if task.create_user.use_im?
        message = "[#{task.project.name}] - #{task.title} のタスクに書き込みがありました。"
        message << "\r\n"
        message << "#{APP_CONFIG[:url]}tasks/show/#{task.id}"
        MiddleMan.get_worker(:task_adder).send_message(task.create_user.im, message)
      end
    rescue
      flash[:error] = 'タスクログの追加に失敗しました。'
      redirect_to :controller => 'tasks', :action => 'show', :id => @task_log.task_id
    end
  end

  def edit
    @task_log = TaskLog.find(params[:id])
  end

  def update
    @task_log = TaskLog.find(params[:id])
    if @task_log.update_attributes(params[:task_log])
      flash[:notice] = 'TaskLog was successfully updated.'
      redirect_to :action => 'show', :id => @task_log
    else
      render :action => 'edit'
    end
  end

  def destroy
    TaskLog.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private 
  
  def log_message(target, from, to)
    "#{target}を「#{from}」から「#{to}」に変更しました。<br>"
  end
end

class TasksController < ApplicationController
  before_filter :signin_filter
  
  helper :sort
  include SortHelper
  
  def index
    list
    render :action => 'list'
  end

  def list
    sort_init 'created_at'
    sort_update
    @task_pages, @tasks = paginate(:task, 
                                    :conditions=>["treat_user_id = ? and complete_at is null ", _user_id], 
                                    :per_page => 10, :order_by => sort_clause)
  end

  def __mobile_list
    project_id = params[:project_id]
    if project_id.nil?
      @task_pages, @tasks = paginate(:task, 
                                      :conditions=>["treat_user_id = ? and complete_at is null ", _user_id], 
                                      :per_page => 5, :order_by => 'created_at')
    else
      @task_pages, @tasks = paginate(:task, 
                                      :conditions=>["treat_user_id = ? and project_id = ? and complete_at is null ", _user_id, project_id], 
                                      :per_page => 5, :order_by => 'created_at')
      @target_project = Project.find(project_id)
    end
    @projects = Project.find(:all)
    render :action => 'list'                               
  end
  
  def show
    @task = Task.find(params[:id])
    @status = Status.find(:all)
    @users = User.find(:all)
    @milestones = Milestone.find_all_by_project_id(@task.project_id)
  end

  def show_detail
    @task = Task.find(params[:id])
    @status = Status.find(:all)
    @users = User.find(:all)
    @milestones = Milestone.find_all_by_project_id(@task.project_id)
  end
  
  def show_task_log
    @task = Task.find(params[:id])
    @status = Status.find(:all)
    @users = User.find(:all)
    @milestones = Milestone.find_all_by_project_id(@task.project_id)
  end
  
  def new
    @task = Task.new
    @task.project_id = params[:project_id]
    
    @milestones = Milestone.find_all_by_project_id(@task.project_id)
    @statuses = Status.find(:all)
    @default_day = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 18, 0)
    
    if @task.project_id.nil?
      @users = User.find(:all)
      @projects = Project.find(:all)
    else
      @project = Project.find(@task.project_id)
      @users = @project.model_user_project_entry_users
    end
  end

  def create
    @task = Task.new(params[:task])
    @task.create_user_id = _user_id
    @task.goal_at = Util.parse_by_day_time(params[:task_goal])
    
    if @task.save
      begin
        Mailer.deliver_add_task(@task)
        if @task.treat_user.use_im?
          message = "[#{@task.project.name}] - #{@task.title} のタスクをふられました\r\n#{APP_CONFIG[:url]}tasks/show/#{@task.id}"
          MiddleMan.get_worker(:task_adder).send_message(@task.treat_user.im, message)
        end
      rescue # 通知は失敗してもロギングだけ
        error($!)
      end
      flash[:notice] = 'タスクを追加しました'
      redirect_to :controller => :projects, :action => 'show', :id => @task.project_id
    else
      render :action => 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @project = @task.project
    @users = @project.model_user_project_entry_users
    @milestones = Milestone.find_all_by_project_id(@project.id)
    @statuses = Status.find(:all)
    @default_day = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 18, 0)
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = 'タスク情報を更新しました。'
      redirect_to :action => 'show', :id => @task
    else
      render :action => 'edit'
    end
  end

  def destroy
    task = Task.find(params[:task][:id])
    task.delete_at = Time.now
    if task.save
      begin
        # 担当者が削除している人と違う場合通知
        if task.treat_user.use_im? && task.create_user_id != task.treat_user_id
          message = "[#{@task.project.name}] - #{@task.title} のタスクは削除されました。"
          MiddleMan.get_worker(:task_adder).send_message(@task.treat_user.im, message)
        end
      rescue # 通知は失敗してもロギングだけ
        error($!)
      end
      flash[:notice] = "タスク「#{task.title}」を削除しました"
      redirect_to :controller => :projects, :action => 'show', :id => task.project_id
    else
      flash[:error] = "タスクの削除に失敗しました。"
      redirect_to :action => 'show', :id => task.id
    end
  end
end

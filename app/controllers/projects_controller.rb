class ProjectsController < ApplicationController
  before_filter :signin_filter
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @project_pages, @projects = paginate :projects, :per_page => 10
  end

  def show
    @project = Project.find(params[:id])
    @statuses = Status.find(:all)
    status = params[:status]
    if status.nil?
      @task_pages, @tasks = paginate(:task, 
                                     :conditions=>["project_id = ? and complete_at is null ", @project.id], 
                                     :per_page => 10, :order_by => 'created_at')
    else
      @task_pages, @tasks = paginate(:task, 
                                     :conditions=>["project_id = ? and status_id = ? ", @project.id, status], 
                                     :per_page => 10, :order_by => 'created_at')
    end
    @task_count_all = Task.count(:conditions=> ["project_id = ? ", @project.id])
    @task_count_complate = Task.count(:conditions=> ["project_id = ? and complete_at is not null ", @project.id])
    
    @complate_rate = @task_count_all == 0 ? 0 : (@task_count_complate.to_f/@task_count_all * 100).truncate
    
    @meetings = Meeting.find_all_by_project_id(@project.id)
  end

  def new
    @project = Project.new
    @project.start_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day, 0, 0)
    @project.goal_at = Time.mktime(Time.now.year, Time.now.month+1, Time.now.day, 0, 0)
      
    @divisions = Division.find(:all)
    @users = User.find(:all)
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    @select_guest_users = Array.new
  end

  def create
    begin
      Project.transaction {
        @project = Project.new(params[:project])
        @project.start_at = Time.parse("#{params[:project_start_at][:day]}")
        @project.goal_at = Time.parse("#{params[:project_goal_at][:day]}")
        @project.owner_id = _user_id
        @project.save
      
        params[:selectUser].each { |selectUser|
          user = ProjectEntryUser.new
          user.project_id = @project.id
          user.user_id = selectUser
          user.save
        }
      }
      flash[:notice] = 'プロジェクトを新規作成しました。'
      redirect_to :action => 'list'
    rescue
      error($!)
      redirect_to :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
    @users = User.find(:all)
    @select_users = @project.model_user_project_entry_users
    @select_guest_users = @project.model_invite_user_project_guest_entry_users
    @divisions = Division.find(:all)
  end
  
  def update
    begin
      Project.transaction {
        @project = Project.find(params[:id])
        @project.start_at = Time.parse("#{params[:project_start_at][:day]}")
        @project.goal_at = Time.parse("#{params[:project_goal_at][:day]}")
        @project.update_attributes(params[:project])
    
        params[:selectUser].each { |select_user|
          user = ProjectEntryUser.find(:first, :conditions=>[" project_id = ? and user_id = ? ", @project.id, select_user])
          user = ProjectEntryUser.new if user.nil?
          user.project_id = @project.id
          user.user_id = select_user
          user.save
        }
        
        unless params[:add_guest].nil?
          params[:add_guest].values.each { |guest_user|
            invite_user = InviteUser.find(:first, :conditions=>[" email = ? ", guest_user])
            invite_user = InviteUser.new if invite_user.nil?
            if invite_user.invite_at.nil?
              invite_user.email = guest_user
              invite_user.invite_code = Util.random_string(32)
              invite_user.from_user_id = _user_id
              invite_user.save
              
              guest_user = ProjectEntryGuestUser.new
              guest_user.project_id = @project.id
              guest_user.invite_user_id = invite_user.id
              guest_user.save
              
              Mailer.deliver_invite_user(invite_user)
            else
              flash[:notice] = "#{guest_user}は招待し登録済みです。"
              raise "added user"
            end
          }
        end
      }
      flash[:notice] = 'プロジェクトの情報を更新しました。'
      redirect_to :action => 'show', :id => @project
    rescue
      error($!)
      redirect_to :action => 'edit', :id => @project
    end
  end

  # メールアドレスサジェスト
  def auto_complete_for_drecom_users
    input_value = params[:invite_user][:email]
    
    unless input_value.nil?
      @users = DrecomUser.find ( :all,
              :conditions => [" email LIKE ? ", '%' +  input_value + '%' ],
              :order => "email ASC",
              :limit => 10 )
      render :inline => "<%= auto_complete_result @users, 'email' %>"
      return 
    end
    render :nothing => true
  end
  
  # ユーザを招待
  def ajax_add_guest
    @key = params[:add_guest_count]
    @email = params[:email]
  end
  
  # ゲストユーザを削除
  def ajax_delete_guest
    @key = params[:id]
  end
  
  # 削除
  def destroy
    project = Project.find(params[:project][:id])
    project.delete_at = Time.now
    if project.save
      flash[:notice] = "プロジェクト「#{project.name}」を削除しました。"
      redirect_to :controller => 'home'
    else
      flash[:error] = "プロジェクトの削除に失敗しました。"
      redirect_to :action => 'show', :id => project.id
    end
  end
end

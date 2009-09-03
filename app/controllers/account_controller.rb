class AccountController < ApplicationController

  def do_signin
    return unless request.post?
    self.current_user = authenticate(params[:user][:login], params[:user][:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/home', :action => 'index')
    else
      flash[:notice] = "パスワードが違います"
      render :action => 'signin'
    end
  end
  
  #ログアウト処理
  def signout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    redirect_back_or_default(:controller => '/account', :action => 'signin')
  end
  
  # 登録処理
  def regist
    invite_code = params[:id]
    @invite_user = InviteUser.find(:first, :conditions=> ['invite_code = ?', invite_code])
    @user = User.new
    @user.email = @invite_user.email
    if @invite_user.nil?
      flash[:error] = "無効な認証キーです"
    elsif !@invite_user.invite_at.nil?
      flash[:info] = "既に認証済みです"
    end
    @divisions = Division.find(:all, :conditions=>["parent_id IS NULL"], :order=>:id)
  end
  
  # 編集
  def edit
    @user = User.find(params[:id])
    @divisions = Division.find(:all, :conditions=>["parent_id IS NULL"], :order=>:id)
  end
  
  # アカウント作成
  def create
    user = User.new(params[:user])
    invite_code = params[:regist][:key]
    
    new_user = User.find_registed_user(user.email, user.office_id)
    if new_user.nil?
      begin
        User.transaction {
          user.log_input_type = false
          user.save
        
          UsersDivision.delete_all(['user_id = ?', user.id])
          params[:divisions].each { |division_id| 
            users_division = UsersDivision.find(:first, :conditions => ["user_id = ? and division_id = ?", user.id, division_id])
            if users_division.nil?
              users_division = UsersDivision.new
              users_division.user_id = user.id
              users_division.division_id = division_id
              users_division.save
            end
          }
          invite_user = InviteUser.find(:first, :conditions => ['invite_code = ?', invite_code])
          invite_user.invite_at = Time.now
          invite_user.save
          
          project_entry_guest_users = ProjectEntryGuestUser.find(:all, :conditions => ['invite_user_id = ?', invite_user.id])
          project_entry_guest_users.each { | project_entry_guest_user |
           
            project_entry_user = ProjectEntryUser.new
            project_entry_user.project_id = project_entry_guest_user.project_id
            project_entry_user.user_id = user.id
            project_entry_user.save
            
            ProjectEntryGuestUser.delete(project_entry_guest_user.id)
          }
        }
      rescue
        error($!)
        redirect_to :action => 'regist', :id => invite_code
        return
      end
    else
      flash[:error] = "登録済みです"
    end
    redirect_to :action => 'signin'
  end
  
  # アカウント更新
  def update
    user = User.find(params[:user][:id])
    
    begin
      User.transaction {
        user.update_attributes(params[:user])
    
        UsersDivision.delete_all(['user_id = ?', user.id])
        params[:divisions].each { |division_id| 
          users_division = UsersDivision.find(:first, :conditions => ["user_id = ? and division_id = ?", user.id, division_id])
          if users_division.nil?
            users_division = UsersDivision.new
            users_division.user_id = user.id
            users_division.division_id = division_id
            users_division.save
          end
        }
      }
      flash[:info] = "アカウント情報を更新しました。"
    rescue
      error($!)
      flash[:error] = "更新処理に問題が発生しました。"
      redirect_to :action => 'edit', :id => _user_id
      return
    end
    redirect_to :controller => 'home'
  end
end

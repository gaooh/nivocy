class MeetingsController < ApplicationController
  before_filter :signin_filter
  in_place_edit_for :meeting_agenda, :title
   
  #　新規作成
  def new
    @meeting = Meeting.new
    @meeting.project_id = params[:project_id]
    
    @users = User.find(:all)
    # select form にするためあえてallでとって配列化
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    
    @default_start_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 9, 30)
    @default_end_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 10, 30)
    @places = Place.findAvailAll
    @divisions = Division.find(:all)
  end
  
  # MTG候補場所を表示
  def ajax_show_pickup_place
    member_count = params[:member_count]
    mtg_time = params[:mtg_time]
    target_day = Time.parse(params[:target_day])
    if Util.today?(target_day)
      target_day_start = Time.mktime(target_day.year, target_day.month, target_day.day, Time.now.hour+1, 0)
    else
      target_day_start = Time.mktime(target_day.year, target_day.month, target_day.day, 9, 30)
    end
    
    target_day_end = target_day_start + 60*60*(mtg_time.to_i/60)
    @appointments = Array.new
    places = Place.find(:all, :conditions => ['occupancy >= ?', member_count])
    places.each do |place|
      mem_target_day_start = target_day_start
      mem_target_day_end = target_day_end
      place_count = 0
      while true do 
        appointment = Appointment.find(:first, :conditions => [' place_id = ? and (( start_at >= ? and start_at < ? ) or ( end_at > ? and end_at < ? )) ', 
                                                                place.id, mem_target_day_start, mem_target_day_end, mem_target_day_start, mem_target_day_end])
        if appointment.nil?
          appointment = Appointment.new
          appointment.place_id = place.id
          appointment.start_at = mem_target_day_start
          appointment.end_at = mem_target_day_end
          @appointments << appointment
          place_count+=1
        end
        mem_target_day_start = appointment.end_at
        mem_target_day_end = appointment.end_at + 60*60*(mtg_time.to_i/60)
        
        break if mem_target_day_start.hour == 23 && mem_target_day_start.min > 29
        break if place_count > 2
      end
    end
  end
  
  # 作成実行
  def create
    begin
      Meeting.transaction {
        @meeting = Meeting.new(params[:meeting])
        @meeting.create_user_id = _user_id
        @meeting.open_flag = true
        @meeting.start_at = Time.parse("#{params[:meeting_start_at][:day]} #{params[:meeting_start_at][:time]}")
        @meeting.end_at = Time.parse("#{params[:meeting_end_at][:day]} #{params[:meeting_end_at][:time]}")
    
        room_schedule = RoomSchedule.new
        room_schedule.user_id = _user_id
        room_schedule.place_id = @meeting.place_id
        room_schedule.start_at = @meeting.start_at
        room_schedule.end_at = @meeting.end_at
        room_schedule.save
        
        @meeting.room_schedule_id = room_schedule.id
        @meeting.save
        
        selectUsers = params[:selectUser]
        selectUsers.each { |selectUser|
          user = MeetingEntryUser.new
          user.meeting_id = @meeting.id
          user.user_id = selectUser
          user.save
        }
      }
      
      @meeting.meeting_entry_users.each { | entry_user |
        Mailer.deliver_add_meeting(entry_user.user, @meeting)
      }
      
      flash[:notice] = '新しくミーティングを設定しました'
      redirect_to :controller => 'projects', :action => 'show', :id => @meeting.project_id
    rescue
      error($!)
      redirect_to :action => 'new'
    end
  end
  
  def show
    @edit_user = User.find(_user_id)
    @meeting = Meeting.find(params[:id])
    @meeting_agendas = MeetingAgenda.find_all_meeting_id(@meeting.id)
  end
  
  def ajax_sort_agenda
    @edit_user = User.find(_user_id)
    @meeting = Meeting.find(params[:id])
    @meeting_agendas = MeetingAgenda.find_all_meeting_id(@meeting.id)
    @users = @meeting.model_user_meeting_entry_users
    @meeting_log_types = MeetingLogType.find(:all)
  end
  
  def ajax_sort_channel_agenda
    @meeting_agendas = MeetingAgenda.find_all_meeting_id(params[:id])
    @channel_id = params[:channel_id].to_i
  end
  
  # ログレコード記述をサジェストする
  def auto_complete_for_meeting_log_record
    meeting_id = params[:id]
    record_text_value = params[:record].values[0]
    record = MeetingLog::REGXP_LOG_RECORD_ONELINER.match(record_text_value)
    
    if record.nil?
      record = MeetingLog::REGXP_LOG_RECORD_ID_TEXT.match(record_text_value)
      
      if record.nil?
        record = MeetingLog::REGXP_LOG_RECORD_ID.match(record_text_value)
        unless record.nil?
          users = User.find ( :all, 
                  :include => :meeting_entry_users,
                  :conditions => [" meeting_entry_users.meeting_id = ? and office_id LIKE ? ", meeting_id, '%' +  record.to_a[MeetingLog::INDEX_LOG_ID] + '%' ],
                  :order => "office_id ASC",
                  :limit => 10 )
          @result_users = Array.new
          users.each {|user| 
            user.office_id = "id:#{user.office_id}"
            @result_users << user
          }
          render :inline => "<%= auto_complete_result @result_users, 'office_id' %>"
          return 
        end
      end
      
    else 
      meeting_log_types = MeetingLogType.find(:all,
        :conditions => [" name LIKE ?", '%' +  record.to_a[MeetingLog::INDEX_LOG_TYPE] + '%' ],
        :order => "name ASC", 
        :limit => 10)
      @result_record = Array.new
      meeting_log_types.each {|meeting_log_type| 
        meeting_log_type.name = "id:#{record.to_a[MeetingLog::INDEX_LOG_ID]} #{record.to_a[MeetingLog::INDEX_LOG_TEXT]};#{meeting_log_type.name}"
        @result_record << meeting_log_type
      }
      render :inline => "<%= auto_complete_result @result_record, 'name' %>"
      return
    end
    render :nothing => true
  end
  
  # アジェンダの追加、更新
  def update_agenda
    add_agendas = params[:add_agenda]
    unless add_agendas.nil?
      add_agendas.each { |title|
        unless title.empty?
          meeting_agenda = MeetingAgenda.new({ :title => title, :meeting_id => params[:meeting][:id] })
          meeting_agenda.save
        end
      }
    end
    redirect_to :action => 'show', :id => params[:meeting][:id]
  end
  
  #　ミーティングの更新用にフォーム調整
  def ajax_edit_meeting_log
    @meeting_log = MeetingLog.find(params[:id])
    @users = @meeting_log.meeting.model_user_meeting_entry_users
    @meeting_log_types = MeetingLogType.find(:all)
  end
  
  #　ミーティングの発言の記録と更新
  def ajax_update_meeting_log
    meeting_log_id = params[:meeting_log][:id]
    if meeting_log_id.empty?
      @meeting_log = MeetingLog.new(params[:meeting_log])
      if @meeting_log.save
        flash[:notice] = '発言を追加しました'
        render :action => 'ajax_insert_meeting_log'
      end
    else
      @meeting_log = MeetingLog.find(meeting_log_id)
      if @meeting_log.update_attributes(params[:meeting_log])
        flash[:notice] = '発言を更新しました'
        render :action => 'ajax_update_meeting_log'
      end
    end
  end
  
  # ミーティングの発言の記録と更新を1行でおこなう
  def ajax_update_meeting_log_oneliner
    @meeting_log = MeetingLog.new(params[:meeting_log])
    record = MeetingLog::REGXP_LOG_RECORD_ONELINER.match(params[:record].values[0])
    if record.nil?
      @err_message = "入力フォーマットに問題があります。 例) id:asami ろぐてきすと;TODO"
      render :action => "ajax_update_meeting_log_oneliner_error"
      return
    end
      
    user_name = record.to_a[MeetingLog::INDEX_LOG_ID]
    user = User.find(:first, :conditions=>["office_id = ? ", user_name])
    if user.nil?
      @err_message = "#{user_name}:ユーザがみつかりません!"
      render :action => "ajax_update_meeting_log_oneliner_error"
      return
    end
    
    type_name = record.to_a[MeetingLog::INDEX_LOG_TYPE]
    meeting_log_type = MeetingLogType.find(:first, :conditions=>["name = ? ", type_name])
    if meeting_log_type.nil?
      @err_message = "#{type_name}:ログタイプに問題があります。"
      render :action => "ajax_update_meeting_log_oneliner_error"
      return
    end
    
    @meeting_log.type_id = meeting_log_type.id
    @meeting_log.voice_user_id = user.id
    @meeting_log.voice = record[MeetingLog::INDEX_LOG_TEXT]
    @meeting_log.save
    render :action => 'ajax_insert_meeting_log'
  end
  
  # ミーティングのログを削除する
  def ajax_delete_meeting_log
    @metting_log_id = params[:id]
    metting_log = MeetingLog.find(@metting_log_id)
    if metting_log.destroy
      flash[:notice] = '発言を削除しました'
    end
  end
  
  # ユーザ一覧を部署で切り替える
  def ajax_update_users
    @users = Division.find(params[:division_id]).users
  end
  
  # ログ入力タイプをワンライナーにかえる
  def user_log_type_oneliner
    user = User.find(_user_id)
    meeting = Meeting.find(params[:id])
    user.log_input_type = User::LOG_INPUT_TYPE_ONELINER
    if user.save
      flash[:notice] = 'ログ入力タイプをワンライナーにしました。'
    end
    redirect_to :action => 'show', :id => meeting.id
  end
  
  # ログ入力タイプを通常タイプにかえる
  def user_log_type_standard
    user = User.find(_user_id)
    meeting = Meeting.find(params[:id])
    user.log_input_type = User::LOG_INPUT_TYPE_STANDARD
    if user.save
      flash[:notice] = 'ログ入力タイプを通常タイプにしました。'
    end
    redirect_to :action => 'show', :id => meeting.id
  end
  
  #　ミーティングを閉会する
  def closed
    meeting = Meeting.find(params[:id])
    meeting.open_flag = false
    if meeting.save
      flash[:notice] = 'ミーティングを閉会しました。'
    end
    redirect_to :action => 'show', :id => meeting.id
  end
  
  #　ミーティングを開催する
  def open
    meeting = Meeting.find(params[:id])
    meeting.open_flag = true
    if meeting.save
      flash[:notice] = 'ミーティングを開催しました。'
    end
    redirect_to :action => 'show', :id => meeting.id
  end
  
  # ミーティングのメンバーへ議事録を送信する
  def send_mail_minutes
    meeting = Meeting.find(params[:id])
    
    meeting.meeting_entry_users.each { | entry_user |
      Mailer.deliver_minutes(entry_user.user, meeting)
    }
    flash[:notice] = 'ミーティングの議事録を送信しました。'
    redirect_to :action => 'show', :id => meeting.id
  end
  
  # 同じメンバーで再度会議を開く
  def reholding
    meeting = Meeting.find(params[:id])
    
    @meeting = Meeting.new
    @meeting.project_id = meeting.project_id
    @users = User.find(:all)
    @select_users = meeting.model_user_meeting_entry_users
    @places = Place.findAvailAll
    
    @default_start_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 9, 30)
    @default_end_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day+1, 10, 30)
    
    @divisions = Division.find(:all)
    render :action => 'new'
  end
  
  #　編集
  def edit
    @meeting = Meeting.find(params[:id])
    
    @users = User.find(:all)
    @divisions = Division.find(:all)
    @select_users = @meeting.model_user_meeting_entry_users
    
    @default_start_at = @meeting.start_at
    @default_end_at = @meeting.end_at
    @places = Place.findAvailAll
  end
  
  # 更新
  def update
    add_users = Array.new
    begin
      Meeting.transaction {
        @meeting = Meeting.find(params[:meeting][:id])
        @meeting.start_at = Time.parse("#{params[:meeting_start_at][:day]}")
        @meeting.end_at = Time.parse("#{params[:meeting_end_at][:day]}")
        @meeting.update_attributes(params[:meeting])
    
        selected_users = MeetingEntryUser.find_all_by_meeting_id(params[:meeting][:id])
        select_users = params[:selectUser]
        selected_users.each { |selected_user| #　まず追加する対象ユーザを取得しておく
          check_selected_user = select_users.index(selected_user.user_id)
          if check_selected_user.nil?
            add_users << selected_user.user_id
          end
        }
        MeetingEntryUser.delte_all_by_meeting_id(params[:meeting][:id])
        select_users.each { |select_user|
          user = MeetingEntryUser.new({:meeting_id => @meeting.id, :user_id => select_user})
          user.save
        }
        
        room_schedule = @meeting.room_schedule
        room_schedule.user_id = _user_id
        room_schedule.place_id = @meeting.place_id
        room_schedule.start_at = @meeting.start_at
        room_schedule.end_at = @meeting.end_at
        room_schedule.save
      }
      
      add_users.each { | user_id |
        user = User.find(user_id)
        Mailer.deliver_add_meeting(user, @meeting)
      }
      
      flash[:notice] = '新しくミーティングを設定しました'
      redirect_to :controller => 'projects', :action => 'show', :id => @meeting.project_id
    rescue
      error($!)
      flash[:error] = 'ミーティングの作成に失敗しました'
      redirect_to :action => 'edit', :id => params[:meeting][:id]
    end
  end
  
  # アジェンダのソート処理
  def agenda_sort
    params[:agenda_list].each_with_index do | agenda_id, index |
      sort_agenda = MeetingAgenda.find(agenda_id)
      sort_agenda.position = index + 1
      sort_agenda.save
    end
    render :nothing => true
  end
  
  # in place edit で MTGのアジェンダタイトルを変更したとき
  def ajax_reset_meeting_agenda_title
    @meeting_agendas = MeetingAgenda.find_all_meeting_id(params[:id])
  end
  
  # 削除
  def destroy
    meeting = Meeting.find(params[:meeting][:id])
    meeting.delete_at = Time.now
    if meeting.save
      flash[:notice] = "ミーティング「#{meeting.title}」を削除しました"
      redirect_to :controller => :projects, :action => :show, :id => meeting.project_id
    else
      flash[:error] = "ミーティングの削除に問題が発生しました。"
      redirect_to :action => :show, :id => meeting.id
    end
  end
end

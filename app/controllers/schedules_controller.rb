class SchedulesController < ApplicationController
  before_filter :signin_filter
  
  # 週表示
  def week
    @users = User.find(:all)
    @divisions = Division.find(:all)
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    
    @base_date = params[:year].nil? ? Date.today : Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    
    @days = Array.new
    for i in 0..6
      day = @base_date + i
      @days << day
    end

    @day_log_schedules = convert_schedule_day_hash(Schedule.findDeyLongWeekByUserId(_user_id, @base_date))
    
    @schedules = Schedule.findWeekByUserId(_user_id, @base_date)
    
    schedule_arrays = convert_schedule_day_hash(@schedules).values
    for schedule_array in schedule_arrays
      setup_width(schedule_array)
    end
  end
  
  #　新規作成処理
  def create
    schedule = Schedule.new(params[:schedule])
    schedule.user_id = _user_id
    
    Schedule.transaction {
      schedule.start_at = Util.parse_by_day_time(params[:schedule_start_at])
      schedule.end_at  = Util.parse_by_day_time(params[:schedule_end_at])
      schedule.save
      
      selectUsers = params[:selectUser]
      selectUsers.each { |selectUser|
          user = ScheduleEntryUser.new
          user.schedule_id = schedule.id
          user.user_id = selectUser
          user.save
      }
    }
    date = schedule.start_at
    redirect_to :action => "week", :year => date.year, :month => date.month, :day => date.day
  end
  
  #　簡易新規作成処理
  def easy_create
    date = Date.parse(params[:setup][:base_date])
    schedule = Schedule.new(params[:schedule])
    schedule.user_id = _user_id
    
    Schedule.transaction {
      schedule.save
      
      user = ScheduleEntryUser.new
      user.schedule_id = schedule.id
      user.user_id = _user_id
      user.save
    } 
    redirect_to :action => "week", :year => date.year, :month => date.month, :day => date.day
  end
  
  #　更新処理
  def update
    schedule = Schedule.find(params[:schedule][:id])
    schedule.user_id = _user_id
    
    Schedule.transaction {
      schedule.start_at = Util.parse_by_day_time(params[:schedule_start_at])
      schedule.end_at  = Util.parse_by_day_time(params[:schedule_end_at])
      schedule.update_attributes(params[:schedule])
  
      ScheduleEntryUser.delete_all_by_schedule_id(schedule.id)
      selectUsers = params[:selectUser]
        selectUsers.each { |selectUser|
          user = ScheduleEntryUser.new
          user.schedule_id = schedule.id
          user.user_id = selectUser
          user.save
      }
    } 
    redirect_to :action => "week", :year => schedule.start_at.year, :month => schedule.start_at.month, :day => schedule.start_at.day
  end
  
  # 週表示での表示領域移動
  def move_day
    date = Date.parse(params[:base_date])
    date += params[:week_value].to_i
    redirect_to :action => 'week', :year => date.year, :month => date.month, :day => date.day
  end
  
  def autoUpdateSchedule
    schedule = Schedule.find(params[:id])
    
    endNum = params[:endTime].to_i
    old_end_time = schedule.end_time
    end_hour = endNum / 2
    end_min = endNum % 2 * 30
    end_time = Time.local(old_end_time.year, old_end_time.month, old_end_time.day,
                          end_hour, end_min)
    schedule.end_time = end_time
    schedule.update

    day = params[:baseDay].to_i
    month = params[:baseMonth].to_i
    year = params[:baseYear].to_i

    redirect_to :action => 'index', :year => year, :month => month, :day => day
  end
  
  # スケジュール編集
  def ajax_show_tb
    @schedule = Schedule.find(params[:schedule_id])
    @base_date = @schedule.start_day
    
    @add_day = @schedule.start_day.cwday
    @start_pos = @schedule.start_pos
    @end_pos = @schedule.end_pos
    
    @users = User.find(:all)
    @select_users = ScheduleEntryUser.find(:all, :conditions=>[" schedule_id = ? ", @schedule])
    @divisions = Division.find(:all)
  end
  
  # スケジュール候補を取得する
  def ajax_show_pickup
    members = params[:member]
    time = params[:time].to_i
    target_day = Time.parse(params[:target_day])
    if Util.today?(target_day)
      target_day_start = Time.mktime(target_day.year, target_day.month, target_day.day, Time.now.hour+1, 0)
    else
      target_day_start = Time.mktime(target_day.year, target_day.month, target_day.day, 9, 30)
    end
    
    target_day_end = time.minutes.from_now(target_day_start)
    @schedules = Array.new
    count = 0
    while true do 
      schedule = Schedule.findTermByUsers(members, target_day_start, target_day_end)
      if schedule.nil?
        schedule = Schedule.new
        schedule.user_id = _user_id
        schedule.start_at = target_day_start
        schedule.end_at = target_day_end
        @schedules << schedule
        count+=1
      end
      target_day_start = schedule.end_at
      target_day_end = time.minutes.from_now(schedule.end_at)
        
      break if target_day_start.hour == 23 && target_day_start.min > 29
      break if count >= 5
    end
  end
  
  # 月別スケジュール表示
  def month
    if params[:year].nil? 
      today = Date.today
      target_day = Date.new(today.year, today.month, 1)
    else
      target_day = Date.new(params[:year].to_i, params[:month].to_i, 1)
    end
    @base_date = target_day
    
    @month_matrix = Hash.new
    while target_day.month == @base_date.month
      hashKey = target_day.yday / 7
      week = @month_matrix[hashKey]
      if week.nil?
        week = Array.new
        0.upto(6) { |index| week[index] = 0 }
      end
      week[target_day.wday] = target_day
      @month_matrix[hashKey] = week
      target_day = target_day.next
    end
    
    @schedules = convert_schedule_day_hash(Schedule.findMonthByUserId(_user_id, @base_date.year, @base_date.month))
    @day_long_schedules = convert_schedule_day_hash(Schedule.findDayLongMonthByUserId(_user_id, @base_date.year, @base_date.month))
    
  end
  
  # 月表示での表示領域移動
  def move_month
    date = Date.parse(params[:base_date])
    date = date >> params[:month_value].to_i
    redirect_to :action => 'month', :year => date.year, :month => date.month
  end
  
  # 日別表示
  def day
    division_id = params[:division_id]
    user_id = params[:user_id]
    
    @users = User.find(:all)
    @divisions = Division.find(:all)
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    
    # 指定日付（なければ今日）から1週間
    if params[:year].nil? 
      today = Date.today
      target_day = Date.new(today.year, today.month, today.day)
    else
      target_day = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    end
    @base_date = target_day
    
    if division_id.nil?
      if user_id.nil?
        @target_users = User.find(:all)
      else
        @target_users = User.find(:all, :conditions=>['id = ?', user_id])
      end
    else    
      @target_users = User.find(:all, :include => :users_divisions, :conditions=>['division_id = ?', division_id])
    end
    
    @schedules_all = Array.new
    for user in @target_users
      schedules = Schedule.find(:all, :include => :schedule_entry_users,
                                 :conditions =>
                                         ["start_at >= ? and end_at <= ? and schedule_entry_users.user_id = ?",
                                         @base_date, @base_date + 1, user.id],
                                 :order => "start_at")
      @schedules_all << schedules
    end

    for schedules in @schedules_all
      setup_width(schedules)
    end
  end
  
  # 個別スケジュール詳細情報表示
  def show
    @schedule = Schedule.find(params[:id])
  end
  
  # 個別スケジュール修正
  def edit
    @schedule = Schedule.find(params[:id])
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    @divisions = Division.find(:all)
    @users = User.find(:all)
  end
  
  # 個別スケジュール作成
  def new
    @schedule = Schedule.new
    @schedule.start_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day, Time.now.hour, 0)
    @schedule.end_at = Time.mktime(Time.now.year, Time.now.month, Time.now.day, Time.now.hour+1, 0)
    
    @select_users = User.find(:all, :conditions=>[" id = ? ", _user_id])
    @divisions = Division.find(:all)
    @users = User.find(:all)
  end
  
  private # ------------------------------------------------------------------------------------------------
  
  # スケジュールを日がキーになっているハッシュに変換
  def convert_schedule_day_hash(schedules)
    schedules_hash = Hash.new
    for schedule in schedules
      key = Date.new(schedule.start_at.year, schedule.start_at.month, schedule.start_at.day)
      key_end = Date.new(schedule.end_at.year, schedule.end_at.month, schedule.end_at.day)
      while key <= key_end
        schedules_hash[key] = Array.new if schedules_hash[key].nil?
        schedules_hash[key] << schedule
        key += 1
      end
    end
    return schedules_hash
  end
  
  def setup_width(schedules)
    array = Array.new
    for i in 0..47
      array[i] = Array.new
    end
    
    # 時間帯ごとに分配
    for schedule in schedules
      start_time = schedule.start_at.hour * 2 + schedule.start_at.min / 30
      end_time = schedule.end_at.hour * 2 + schedule.end_at.min / 30

      for key in start_time..end_time - 1
        array[key] << schedule
      end
    end
    
    # length が大きい順に並べ替え
    sorted = array.sort{|a, b| b.length - a.length}
    
    for i in 0..sorted.length - 1
      sub_schedules = sorted[i]
      length = sub_schedules.length
      
      for j in 0..sub_schedules.length - 1
        schedule = sub_schedules[j]
        if schedule.width == nil
          schedule.width , schedule.left_margin = calc_width_and_left_margin(schedule, array, length)
        end
      end
    end
  end

  BASIC_SIZE = 90
  
  # 適切に配置できる width, left_margin を計算して返す
  def calc_width_and_left_margin(schedule, array, count)
    width = BASIC_SIZE / count
    left_margin = 0
    conflicts = make_conflicts(schedule, array)
      
    # 隙間探し
    for other in conflicts
      if left_margin < other.left_margin + other.width and left_margin + width > other.left_margin
        left_margin = other.left_margin + other.width + 1
      end
    end
    
    # 右にはみだしているなら、横幅を小さくしてやり直し
    if left_margin + width > BASIC_SIZE + 1
      return calc_width_and_left_margin(schedule, array, count + 1)
    end
    
    return [width, left_margin]
  end

  # 干渉する（重なる時間帯が存在する）スケジュールの配列を返す
  # 左に配置されているスケジュールから順番に並ぶようにソート済
  # まだ配置されていない（width, left_margin が決まっていない）  スケジュールは除く
  def make_conflicts(schedule, array)
    start_time = schedule.start_at.hour * 2 + schedule.start_at.min / 30
    end_time = schedule.end_at.hour * 2 + schedule.end_at.min / 30

    conflicts = Array.new
    for key in start_time..end_time - 1
      for other in array[key]
        if other.width == nil or other.width == 0
          next
        end
        conflicts << other
      end
    end
    conflicts.uniq!
    conflicts.sort!{|a, b| a.left_margin - b.left_margin}
  end
  
end

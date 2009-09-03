# == Schema Information
# Schema version: 49
#
# Table name: schedules
#
#  id            :integer(11)     not null, primary key
#  user_id       :integer(11)     not null
#  title         :string(200)     default(""), not null
#  description   :string(4000)    default(""), not null
#  start_at      :datetime        not null
#  end_at        :datetime        not null
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  deleted_at    :datetime        
#  day_long_flag :boolean(1)      not null
#

class Schedule < ActiveRecord::Base
  attr_accessor :width, :left_margin
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :user
  has_many   :schedule_entry_users
  
  # 開始日をDate型で返す
  def start_day
    Date.new(self.start_at.year, self.start_at.month, self.start_at.day)
  end
  
  # 開始時間からカレンダー表示した際のセルの開始位置を表す
  def start_pos
    self.start_at.hour * 2 + self.start_at.min / 30
  end
  
  def end_pos
    self.end_at.hour * 2 + self.end_at.min / 30
  end
  
  def self.findTermByUsers(user_ids, start_at, end_at)
    find(:first, :conditions => [' user_id IN (?) and (
                                    ( start_at >= ? and start_at < ? ) or ( end_at > ? and end_at < ? ) or ( start_at < ? and end_at  > ?)) ', 
                                  user_ids, start_at, end_at, start_at, end_at, start_at, end_at])
  end
  
  # user_id の今日の予定を開始時間順にソートしてかえす
  def self.findTodayByUserId(user_id)
    today = Date.today
    start_at = Time.mktime(today.year, today.month, today.day, 0, 0, 0)
    end_at = Time.mktime(today.year, today.month, today.day, 23, 59, 59)
    
    find(:all, :conditions => ["user_id = ? and start_at >= ? and end_at <= ?", user_id, start_at, end_at ], :order => "start_at")
  end
  
  # user_id の今週の予定を開始時間順にソートしてかえす
  def self.findWeekByUserId(user_id, base_date)
    helperFindWeekByUserId(user_id, base_date, false)                             
  end
  
  # user_id の今週の終日予定を開始時間順にソートしてかえす
  def self.findDeyLongWeekByUserId(user_id, base_date)
    helperFindWeekByUserId(user_id, base_date, true)
  end
  
  # user_id の指定月の予定を開始時間順にソートしてかえす
  def self.findMonthByUserId(user_id, year, month)
    helperFindMonthByUserId(user_id, year, month, false)
  end
  
  # user_id の指定月の終日予定を開始時間順にソートしてかえす
  def self.findDayLongMonthByUserId(user_id, year, month)
    helperFindMonthByUserId(user_id, year, month, true)
  end
  
  private 
  
  def self.helperFindWeekByUserId(user_id, base_date, day_long_flag)
    start_at = base_date
    end_at = base_date + 7
    
    helperFindDayByUserId(user_id, start_at, end_at, day_long_flag)
  end
  
  def self.helperFindMonthByUserId(user_id, year, month, day_long_flag)
    start_at = Date.new(year, month, 1)
    end_at = (start_at >> 1) - 1
    
    helperFindDayByUserId(user_id, start_at, end_at, day_long_flag)
  end
  
  def self.helperFindDayByUserId(user_id, start_at, end_at, day_long_flag)
    find(:all, 
         :conditions => ["user_id = ? and day_long_flag = ? and (
                          ( start_at >= ? and start_at <= ? ) or ( end_at >= ? and end_at <= ? ) or ( start_at <= ? and end_at >= ?))", 
                          user_id, day_long_flag, start_at, end_at, start_at, end_at, start_at, end_at], 
         :order => "start_at")
  end
end

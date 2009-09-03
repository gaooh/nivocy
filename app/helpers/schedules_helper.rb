module SchedulesHelper
  
  def height(schedule)
    return ((schedule.end_at - schedule.start_at) / 60 / 30 * 20 - 11)
  end
  
  def width(schedule)
    start_time, end_time = calc_indexes(schedule)
    return (end_time - start_time) * 15
  end
  
  # top の位置を判断するための index を返す
  def top_index(schedule)
    return schedule.start_at.hour * 2 + schedule.start_at.min / 30
  end
  
  # left の位置を判断するための index を返す
  def left_index(schedule, base_date)
    schedule_date = Date.new(schedule.start_at.year, schedule.start_at.month, schedule.start_at.day)
    return schedule_date - base_date + 1
  end
  
  private
  def calc_indexes(schedule)
    start_time = schedule.start_at.hour * 2 + schedule.start_at.min / 30
    end_time = schedule.end_at.hour * 2 + (schedule.end_at.min / 30.0).ceil

    if end_time == 0 && schedule.end_at.day != schedule.start_at.day
      end_time = 48
    end
    
    return [start_time, end_time]
  end
end

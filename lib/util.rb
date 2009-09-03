
class Util
  RAND_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz"

  # ランダムな英数字を生成する
  def self.random_string(len)
    rand_max = RAND_CHARS.size
    ret = ""
    len.times{ ret << RAND_CHARS[rand(rand_max)] }
    ret
  end
  
  def self.today?(time)
    same_day?(time, Time.now)
  end
  
  # 同じ日かをどうかを判断する
  def self.same_day?(time1, time2)
    if time1.year == time2.year && time1.month == time2.month && time1.day == time2.day
      return true
    end
    return false
  end
  
  # dayとtimeからなるHashからTimeを生成する
  def self.parse_by_day_time(hash)
    if hash[:time].nil?
      Time.parse("#{hash[:day]}")
    else
      Time.parse("#{hash[:day]} #{hash[:time]}")
    end
  end
  
end
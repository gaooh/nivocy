class AddDayLongFlag < ActiveRecord::Migration
  def self.up
    add_column(:schedules, :day_long_flag, :boolean, :null => false, :defalut => false)
  end

  def self.down
    remove_column(:schedules, :day_long_flag)
  end
end

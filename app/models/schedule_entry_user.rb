# == Schema Information
# Schema version: 49
#
# Table name: schedule_entry_users
#
#  id          :integer(11)     not null, primary key
#  schedule_id :integer(11)     not null
#  user_id     :integer(11)     not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  deleted_at  :datetime        
#

class ScheduleEntryUser < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :schedule
  
  def self.delete_all_by_schedule_id(schedule_id)
    delete_all([" schedule_id = ? ", schedule_id])
  end
end

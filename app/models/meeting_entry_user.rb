# == Schema Information
# Schema version: 49
#
# Table name: meeting_entry_users
#
#  id         :integer(11)     not null, primary key
#  meeting_id :integer(11)     not null
#  user_id    :integer(11)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class MeetingEntryUser < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :meeting
  belongs_to :user
  
  def self.find_all_by_meeting_id(meeting_id)
    find(:all, :conditions=>[" meeting_id = ? ", meeting_id])
  end
  
  def self.delte_all_by_meeting_id(meeting_id)
    delete_all([" meeting_id = ? ", meeting_id])
  end
end

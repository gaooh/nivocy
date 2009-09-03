# == Schema Information
# Schema version: 49
#
# Table name: meeting_agendas
#
#  id         :integer(11)     not null, primary key
#  meeting_id :integer(11)     not null
#  title      :string(2000)    default(""), not null
#  position   :integer(11)     default(1), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class MeetingAgenda < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :meeting
  
  has_many   :meeting_logs
  
  def self.find_all_meeting_id(meeting_id)
    find(:all, :conditions => ["meeting_id = ?", meeting_id ], :order => "position")
  end
  
end

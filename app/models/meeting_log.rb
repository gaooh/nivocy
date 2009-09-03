# == Schema Information
# Schema version: 49
#
# Table name: meeting_logs
#
#  id                :integer(11)     not null, primary key
#  meeting_id        :integer(11)     not null
#  voice             :string(2000)    default(""), not null
#  voice_user_id     :integer(11)     
#  type_id           :integer(11)     
#  meeting_agenda_id :integer(11)     not null
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  deleted_at        :datetime        
#

class MeetingLog < ActiveRecord::Base
  REGXP_LOG_RECORD_ID = /id:([^ ]+)/
  REGXP_LOG_RECORD_ID_TEXT = "/id:([^ ]+)([^;]+)/"
  REGXP_LOG_RECORD_ONELINER = /id:([^ ]+)([^;]+);(.*)/
  INDEX_LOG_ID = 1
  INDEX_LOG_TEXT = 2
  INDEX_LOG_TYPE = 3
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :meeting
  belongs_to :meeting_agenda
  belongs_to :meeting_log_type, :foreign_key => 'type_id'
  belongs_to :user, :foreign_key => 'voice_user_id'
  
  def todo?
    self.type_id == MeetingLogType::TODO
  end
  
  def conclusion?
    self.type_id == MeetingLogType::CONCLUSION
  end
  
end

# == Schema Information
# Schema version: 49
#
# Table name: meeting_log_types
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class MeetingLogType < ActiveRecord::Base
  MEMO = 1
  IDEA = 2
  MIND = 3
  TODO = 4
  CONCLUSION = 5
  
end

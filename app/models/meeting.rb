# == Schema Information
# Schema version: 49
#
# Table name: meetings
#
#  id                  :integer(11)     not null, primary key
#  project_id          :integer(11)     not null
#  create_user_id      :integer(11)     not null
#  facilitator_user_id :integer(11)     
#  clerk_user_id       :integer(11)     
#  title               :string(2000)    default(""), not null
#  start_at            :datetime        
#  created_at          :datetime        
#  place_id            :integer(11)     not null
#  end_at              :datetime        not null
#  updated_at          :datetime        not null
#  deleted_at          :datetime        
#  open_flag           :boolean(1)      not null
#  room_schedule_id    :integer(11)     not null
#

class Meeting < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :project
  
  belongs_to :create_user, :class_name => "User", :foreign_key => 'create_user_id'
  belongs_to :facilitator, :class_name => "User", :foreign_key => 'facilitator_user_id'
  belongs_to :clerk, :class_name => "User", :foreign_key => 'clerk_user_id'
  
  belongs_to :room_schedule
  
  belongs_to :place
  has_many   :meeting_logs
  has_many   :meeting_entry_users
  has_many   :meeting_agendas
  
  def self.find_entry_meeting(user_id)
    find(:all, :include => :meeting_entry_users, :conditions => ['end_at > ? and user_id = ? ', Time.now, user_id])
  end
  
  def self.find_all_by_project_id(project_id)
    find(:all, :include => :meeting_entry_users, :conditions => ['project_id = ? ', project_id])
  end
  
  # 参加ユーザを　meeting_entry_users model ではなく user model で返す
  def model_user_meeting_entry_users
    users = Array.new
    self.meeting_entry_users.each { | entry_users |
      users << entry_users.user
    }
    return users
  end
  
end

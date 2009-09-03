# == Schema Information
# Schema version: 49
#
# Table name: projects
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  summary    :string(2000)    default(""), not null
#  owner_id   :integer(11)     not null
#  start_at   :datetime        not null
#  goal_at    :datetime        not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class Project < ActiveRecord::Base
  acts_as_paranoid
  
  # --------------------------
  # relation
  # --------------------------
  belongs_to :user, :foreign_key=>"owner_id"
  has_many :task
  has_many :meetings
  has_many :project_entry_users
  has_many :project_entry_guest_users
  has_many :project_attachments
  has_many :milestones
    
  # 指定user_idが参加しているプロジェクト一覧を返す
  def self.find_all_by_user_id(user_id)
    find(:all, :include=>:project_entry_users, :conditions=>["project_entry_users.user_id = ? ", user_id])
  end
  
  # 参加ユーザを　project_entry_user model ではなく user model で返す
  def model_user_project_entry_users
    users = Array.new
    self.project_entry_users.each { | project_entry_user |
     users << project_entry_user.user
    }
    return users
  end
  
  # 参加ゲストユーザを　project_entry_guest_user model ではなく invite user model で返す
  def model_invite_user_project_guest_entry_users
    users = Array.new
    self.project_entry_guest_users.each { | project_entry_guest_user |
     users << project_entry_guest_user.invite_user
    }
    return users
  end
   
end

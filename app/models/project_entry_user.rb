# == Schema Information
# Schema version: 49
#
# Table name: project_entry_users
#
#  id         :integer(11)     not null, primary key
#  project_id :integer(11)     not null
#  user_id    :integer(11)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class ProjectEntryUser < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :project
  belongs_to :user
end

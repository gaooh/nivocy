# == Schema Information
# Schema version: 49
#
# Table name: project_entry_guest_users
#
#  id             :integer(11)     not null, primary key
#  project_id     :integer(11)     not null
#  invite_user_id :integer(11)     not null
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  deleted_at     :datetime        
#

class ProjectEntryGuestUser < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :invite_user
  belongs_to :project
end

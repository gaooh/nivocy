# == Schema Information
# Schema version: 49
#
# Table name: users_divisions
#
#  id          :integer(11)     not null, primary key
#  user_id     :integer(11)     not null
#  division_id :integer(11)     not null
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  deleted_at  :datetime        
#

class UsersDivision < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :user
  belongs_to :division
  
  acts_as_paranoid
end

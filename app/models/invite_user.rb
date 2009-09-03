# == Schema Information
# Schema version: 49
#
# Table name: invite_users
#
#  id           :integer(11)     not null, primary key
#  email        :string(256)     default(""), not null
#  invite_code  :string(32)      default(""), not null
#  from_user_id :integer(11)     not null
#  invite_at    :datetime        
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#  deleted_at   :datetime        
#

class InviteUser < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :from_user, :class_name => "User", :foreign_key => 'from_user_id'
  
end

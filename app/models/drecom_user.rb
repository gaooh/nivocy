# == Schema Information
# Schema version: 49
#
# Table name: drecom_users
#
#  id         :integer(11)     not null, primary key
#  email      :string(256)     default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class DrecomUser < ActiveRecord::Base
end

# == Schema Information
# Schema version: 49
#
# Table name: statuses
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class Status < ActiveRecord::Base
  COMPLETION = 7
end

# == Schema Information
# Schema version: 49
#
# Table name: places
#
#  id         :integer(11)     not null, primary key
#  name       :string(200)     default(""), not null
#  delete_at  :date            
#  occupancy  :integer(11)     not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class Place < ActiveRecord::Base
  
  def self.findAvailAll
    Place.find(:all, :conditions => 'delete_at is null')
  end
end

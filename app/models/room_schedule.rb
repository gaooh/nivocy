# == Schema Information
# Schema version: 49
#
# Table name: room_schedules
#
#  id         :integer(11)     not null, primary key
#  place_id   :integer(11)     not null
#  user_id    :integer(11)     not null
#  start_at   :datetime        not null
#  end_at     :datetime        not null
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  deleted_at :datetime        
#

class RoomSchedule < ActiveRecord::Base
end

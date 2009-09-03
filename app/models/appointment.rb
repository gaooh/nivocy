class Appointment < ActiveRecord::Base
  # --------------------------
  # relation
  # --------------------------
  belongs_to :place
  belongs_to :meeting
  
end

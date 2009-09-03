class AppointmentsController < ApplicationController
  
  def show
    target_day = params[:date]
    target_day = target_day.nil? ? Time.now : Time.parse(target_day)
    
    target_day_start = Time.mktime(target_day.year, target_day.month, target_day.day, 0, 0, 0)
    target_day_end = Time.mktime(target_day.year, target_day.month, target_day.day, 23, 59, 59)
    
    @hour_dates = Array.new
    @min_dates = Array.new
    8.upto(24) do |hour|
      @hour_dates << hour
      0.step(59, 30) do |min|
        @min_dates << min
      end
    end
    
    @appointments_at_place = Hash.new
    
    @places = Place.find(:all)
    @places.each do |place|
      check_sheet = Hash.new
      8.upto(24) do |hour|
        0.step(59, 30) do |min|
          check_sheet["#{hour}:#{min}"] = false
        end
      end
      
      appointments = Appointment.find(:all, :conditions => [' place_id = ? and start_at between ? and ? ', place.id, target_day_start, target_day_end])
      appointments.each do |appointment|
        appointment.start_at.hour.upto(appointment.end_at.hour) do |hour|
          start_pos = hour == appointment.start_at.min ? appointment.start_at.min : 0
          end_pos = hour == appointment.end_at.min ? appointment.end_at.min : 59
        
          start_pos.step(end_pos, 30) do |min|
            check_sheet["#{hour}:#{min}"] = true
          end
        end
      end
      @appointments_at_place[place.id] = check_sheet
    end
    @container_calendar = true
  end
  
end

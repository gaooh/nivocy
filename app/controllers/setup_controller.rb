class SetupController < ApplicationController
  before_filter :signin_filter
  
  def edit
    @milestones = Milestone.find(:all)
    @statuses = Status.find(:all)
    @places = Place.findAvailAll
  end
  
  def update
    _update_milestones
    
    _update_statuses
    _add_statuses
    
    _update_places
    _add_places
    
    redirect_to :action => 'edit'
  end
  
private 

  def _update_milestones
    milestones = params[:milestone]
    unless milestones.nil?
      keys = milestones.keys
      keys.each { |key|
        milestone = Milestone.find(key)
        if !milestone.nil? && milestones[key].empty?
           Milestone.delete(key)
        else 
          if milestone.nil?
            milestone = Milestone.new
          end
          milestone.name = milestones[key]
          milestone.save
        end
      }
    end
    add_milestones = params[:add_milestone]
    unless add_milestones.nil?
      add_milestones.each { |name|
        unless name.empty?
          milestone = Milestone.new({ :name => name })
          milestone.save
        end
      }
    end
  end
  
  # 既存の「状態」を変更
  def _update_statuses
    statuses = params[:status]
    return if statuses.nil?
    
    statuses.keys.each { |key|
      status = Status.find(key)
      if !status.nil? && statuses[key].empty?
         Status.delete(key)
      else 
        status = Status.new if status.nil?
        status.name = statuses[key]
        status.save
      end
    }
  end
  
  # 「状態」を追加
  def _add_statuses
    add_statuses = params[:add_status]
    return if add_statuses.nil?
    
    add_statuses.each { |name|
      unless name.empty?
        status = Status.new({ :name => name })
        status.save
      end
    }
  end
  
  # 既存の「場所」を変更
  def _update_places
    places = params[:place]
    return if places.nil?
    
    places.keys.each { |key|
      place = Place.find(key)
      if !place.nil? && places[key].empty?
         place.delete_at = Time.now 
         place.save
      else 
        place = Place.new if place.nil?
        place.name = places[key]
        place.save
      end
    }
  end
  
  # 「場所」を追加
  def _add_places
    add_places = params[:add_place]
    return if add_places.nil?
    
    add_places.each { |name|
      unless name.empty?
        place = Place.new({ :name => name })
        place.save
      end
    }
  end
end

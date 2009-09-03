class ChangePlace < ActiveRecord::Migration
  def self.up
    add_column(:meetings, :place_id, :integer, :null => false)
    remove_column(:meetings, :place)
    
    add_column(:places, :delete_at, :date, :null => true)
  end

  def self.down
    add_column(:meetings, :place, :string, :limit => 200, :null => true)
    remove_column(:meetings, :place_id)
    
    remove_column(:places, :delete_at)
  end
end

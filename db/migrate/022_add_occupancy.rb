class AddOccupancy < ActiveRecord::Migration
  def self.up
    add_column(:places, :occupancy, :integer, :null => false)
  end

  def self.down
  end
end

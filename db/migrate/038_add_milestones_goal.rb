class AddMilestonesGoal < ActiveRecord::Migration
  def self.up
    add_column(:milestones, :description, :string, :limit => 500, :null => true)
    add_column(:milestones, :goal_at, :datetime, :null => false)
    add_column(:milestones, :delete_at, :datetime, :null => true)
  end

  def self.down
    remove_column(:milestones, :description)
    remove_column(:milestones, :goal_at)
    remove_column(:milestones, :delete_at)
  end
end

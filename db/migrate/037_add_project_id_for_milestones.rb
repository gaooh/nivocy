class AddProjectIdForMilestones < ActiveRecord::Migration
  def self.up
    add_column(:milestones, :position, :integer, :null => false)
    add_column(:milestones, :project_id, :integer, :null => false)
  end

  def self.down
    remove_column(:milestones, :position)
    remove_column(:milestones, :project_id)
  end
end

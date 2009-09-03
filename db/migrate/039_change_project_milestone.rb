class ChangeProjectMilestone < ActiveRecord::Migration
  def self.up
    change_column(:tasks, :milestone_id, :integer, :null => true, :default => nil)
  end

  def self.down
    change_column(:tasks, :milestone_id, :integer, :null => false)
  end
end

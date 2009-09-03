class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.column "name",           :string,   :limit => 200,   :null => false
    end
  end

  def self.down
    drop_table :milestones
  end
end

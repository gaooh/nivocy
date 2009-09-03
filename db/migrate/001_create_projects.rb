class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.column "name",           :string,   :limit => 200,   :null => false
      t.column "summary",        :string,   :limit => 2000,   :null => false
      t.column "owner_id",       :integer,  :null => false
      t.column "start_at",       :datetime,  :null => false
      t.column "goal_at",        :datetime,  :null => false
    end
  end

  def self.down
    drop_table :projects
  end
end

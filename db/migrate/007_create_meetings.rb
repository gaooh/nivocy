class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.column "project_id",             :integer,  :null => false
      t.column "create_user_id",         :integer,  :null => false
      t.column "facilitator_user_id",    :integer,  :null => true
      t.column "clerk_user_id",          :integer,  :null => true
      t.column "title",                  :string,   :limit => 2000,   :null => false
      t.column "place",                  :string,   :limit => 200,   :null => true
      t.column "holding_at",             :datetime,  :null => false
      t.column "create_at",              :datetime,  :null => false
    end
  end

  def self.down
    drop_table :meetings
  end
end

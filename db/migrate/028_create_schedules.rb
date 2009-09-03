class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.column "user_id",            :integer,    :null => false
      t.column "title",              :string,     :limit => 200,    :null => false
      t.column "description",        :string,     :limit => 4000,   :null => false
      t.column "start_at",           :datetime,   :null => false
      t.column "end_at",             :datetime,   :null => false
      t.column "created_at",         :datetime,   :null => false
      t.column "updated_at",         :datetime,   :null => false
      t.column "delete_at",          :datetime,   :null => true
    end
  end

  def self.down
    drop_table :schedules
  end
end

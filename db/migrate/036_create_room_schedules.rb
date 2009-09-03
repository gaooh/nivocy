class CreateRoomSchedules < ActiveRecord::Migration
  def self.up
    create_table :room_schedules do |t|
      t.column "place_id",          :integer,    :null => false
      t.column "user_id",           :integer,    :null => false
      t.column "start_at",          :datetime,   :null => false
      t.column "end_at",            :datetime,   :null => false
      t.column "created_at",        :datetime,   :null => false
      t.column "updated_at",        :datetime,   :null => false
      t.column "delete_at",         :datetime,   :null => true
    end
    add_column(:meetings, :room_schedule_id, :integer, :null => false)
    drop_table :appointments
  end

  def self.down
    drop_table :room_schedules
    create_table :appointments do |t|
      t.column "place_id",          :integer,    :null => false
      t.column "user_id",           :integer,    :null => false
      t.column "start_at",          :datetime,   :null => false
      t.column "end_at",            :datetime,   :null => false
      t.column "create_at",         :datetime,   :null => false
      t.column "update_at",         :datetime,   :null => false
      t.column "delete_at",         :datetime,   :null => true
    end
    remove_coloumn(:meetings, :room_schedule_id)
  end
end

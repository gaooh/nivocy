class CreateAppointments < ActiveRecord::Migration
  def self.up
    create_table :appointments do |t|
      t.column "place_id",          :integer,    :null => false
      t.column "user_id",           :integer,    :null => false
      t.column "start_at",          :datetime,   :null => false
      t.column "end_at",            :datetime,   :null => false
      t.column "create_at",         :datetime,   :null => false
      t.column "update_at",         :datetime,   :null => false
      t.column "delete_at",         :datetime,   :null => true
    end
  end

  def self.down
    drop_table :appointments
  end
end

class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.column "name",           :string,   :limit => 200,   :null => false
    end
  end

  def self.down
    drop_table :statuses
  end
end

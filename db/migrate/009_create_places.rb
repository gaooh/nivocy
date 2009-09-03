class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.column "name",           :string,   :limit => 200,   :null => false
    end
  end

  def self.down
    drop_table :places
  end
end

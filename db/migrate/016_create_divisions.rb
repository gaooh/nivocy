class CreateDivisions < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.column "name",             :string,   :limit => 200,   :null => false
    end
    
    create_table :users_divisions do |t|
      t.column "user_id",           :integer,  :null => false
      t.column "division_id",           :integer,  :null => false
    end
  end

  def self.down
    drop_table :divisions
    drop_table :users_divisions
  end
end

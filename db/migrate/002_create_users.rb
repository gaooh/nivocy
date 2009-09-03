class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column "office_id",        :string,   :limit => 200,   :null => false
      t.column "passwd",    :integer,  :null => false
      t.column "email",    :integer,  :null => false
    end
  end

  def self.down
    drop_table :users
  end
end

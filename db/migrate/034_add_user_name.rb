class AddUserName < ActiveRecord::Migration
  def self.up
    add_column(:users, :name, :string, :limit => 200, :null => false)
    add_column(:users, :password, :string, :limit => 32, :null => false)
    change_column(:users, :office_id, :string, :limit => 100, :null => true)
  end

  def self.down
    remove_column(:users, :name)
    remove_column(:users, :password)
    change_column(:users, :office_id, :string, :limit => 200, :null => false)
  end
end

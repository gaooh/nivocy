class AddUserInputType < ActiveRecord::Migration
  def self.up
    add_column(:users, :log_input_type, :integer, :null => false, :defalut => 1)
  end

  def self.down
    remove_column(:users, :log_input_type)
  end
end

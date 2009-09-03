class AddOpenFlag < ActiveRecord::Migration
  def self.up
    add_column(:meetings, :open_flag, :boolean, :null => false, :defalut=>true)
  end

  def self.down
    remove_column(:meetings, :open_flag)
  end
end

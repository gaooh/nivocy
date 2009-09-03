class AddIm < ActiveRecord::Migration
  def self.up
    add_column(:users, :im, :string, :limit => 256, :null => true)
  end

  def self.down
    remove_column(:users, :im)
  end
end

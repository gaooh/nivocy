class AddDivisionParent < ActiveRecord::Migration
  def self.up
    add_column(:divisions, :parent_id, :integer, :null => true)
  end

  def self.down
    remove_column(:divisions, :parent_id)
  end
end

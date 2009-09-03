class AddComment < ActiveRecord::Migration
  def self.up
    add_column(:project_attachments, :comment, :string, :limit => 2000, :null => true)
  end

  def self.down
    remove_column(:project_attachments, :comment)
  end
end

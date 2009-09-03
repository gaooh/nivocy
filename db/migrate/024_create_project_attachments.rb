class CreateProjectAttachments < ActiveRecord::Migration
  def self.up
    create_table :project_attachments do |t|
      t.column "project_id",         :integer,    :null => false
      t.column "user_id",            :integer,    :null => false
      t.column "content_type",       :string,     :limit => 128,   :null => false
      t.column "org_filename",       :string,     :limit => 200,   :null => false
      t.column "size",               :integer,    :null => false
      t.column "created_at",         :datetime,   :null => false
      t.column "updated_at",         :datetime,   :null => false
      t.column "delete_at",          :datetime,   :null => true
    end
    execute "alter table project_attachments add file_data LONGBLOB;"
  end

  def self.down
    drop_table :project_files
  end
end

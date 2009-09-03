class CreateIdeaAttachements < ActiveRecord::Migration
  def self.up
    drop_table :idea_images;
    
    create_table :idea_attachments do |t|
      t.column "idea_id",            :integer,    :null => false
      t.column "user_id",            :integer,    :null => false
      t.column "content_type",       :string,     :limit => 128,   :null => false
      t.column "org_filename",       :string,     :limit => 200,   :null => false
      t.column "size",               :integer,    :null => false
      t.column "created_at",         :datetime,   :null => false
      t.column "updated_at",         :datetime,   :null => false
      t.column "deleted_at",         :datetime,   :null => true
    end
    execute "alter table idea_attachments add file_data LONGBLOB;"
  end

  def self.down
    drop_table :idea_attachments
    
    create_table :idea_images do |t|
      t.column "idea_id",              :integer,    :null => false
      t.column "filename",             :string,     :limit => 256,   :null => false
      t.column "org_filename",         :string,     :limit => 256,   :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
    
  end
end

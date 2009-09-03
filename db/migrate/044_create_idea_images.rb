class CreateIdeaImages < ActiveRecord::Migration
  def self.up
    create_table :idea_images do |t|
      t.column "idea_id",              :integer,    :null => false
      t.column "filename",             :string,     :limit => 256,   :null => false
      t.column "org_filename",         :string,     :limit => 256,   :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
  end

  def self.down
    drop_table :idea_images
  end
end

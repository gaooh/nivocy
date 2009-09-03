class CreateIdeaGrades < ActiveRecord::Migration
  def self.up
    create_table :idea_grades do |t|
      t.column "idea_id",              :integer,    :null => false
      t.column "user_id",              :integer,    :null => false
      t.column "grade_type_id",        :integer,    :null => false
      t.column "value",                :integer,    :null => false
      t.column "created_at",           :datetime,   :null => false
      t.column "updated_at",           :datetime,   :null => false
      t.column "deleted_at",           :datetime,   :null => true
    end
  end

  def self.down
    drop_table :idea_grades
  end
end

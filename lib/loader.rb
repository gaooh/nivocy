module Loader
  class DataAlreadyLoaded < Exception; end
      
  class << self
    def no_data?
      !IdeaCategory.find(:first) |
      !GradeType.find(:first) |
      !IdeaCommentType.find(:first)
    end
      
    def load
      raise DataAlreadyLoaded.new("Some configuration data is already loaded.") unless no_data?
        
      IdeaCategory.transaction do
        IdeaCategory.create! :name => '社内改善'
        IdeaCategory.create! :name => 'ビジネス'
        IdeaCategory.create! :name => '開発効率化'
        IdeaCategory.create! :name => 'その他'
      end
      
      GradeType.transaction do
        GradeType.create! :name => '収益性'
        GradeType.create! :name => '成長性'
        GradeType.create! :name => '安全性'
        GradeType.create! :name => '効率性'
        GradeType.create! :name => 'with entertainment'
      end
      
      IdeaCommentType.transaction do
        IdeaCommentType.create! :name => '不支持'
        IdeaCommentType.create! :name => '支持'
        IdeaCommentType.create! :name => '中立'
      end
    end
  end
end  

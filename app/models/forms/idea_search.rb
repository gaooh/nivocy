module Forms
  class IdeaSearch < ActiveForm
    include ActiveRecord::Validations
    attr_accessor :word, :idea_category_id

    def word
      @word.nil? ? '' : @word
    end
    
    def idea_category_id
      @idea_category_id.nil? ? '' : @idea_category_id
    end
    
    def validate
    end
  end
end
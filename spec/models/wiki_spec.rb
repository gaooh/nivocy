require File.dirname(__FILE__) + '/../spec_helper'

describe Wiki do
  fixtures :wikis
  before(:each) do
    @wiki = Wiki.find(1)
  end

  it "titleが正しい事" do
    @wiki.title.should eql "testn"
  end
end

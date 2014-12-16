require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 categories' do
    expect(@zype.categories.all({}).class).to eq(Zype::Categories)
  end

  it 'can find a category' do
    first_category = @zype.categories.all({}).first

    expect(@zype.categories.find(first_category._id).class).to eq(Zype::Category)
  end

  it 'can update a category' do
    first_category = @zype.categories.all({}).first
    original_title = first_category.title

    first_category.title = original_title + 'NOT'
    first_category.save

    expect(first_category.title).to_not eq(original_title)
  end
end

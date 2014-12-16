require 'spec_helper'

describe Zype::Client, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'get first 25 videos' do
    params = {:q=>nil, :type=>nil, :category=>nil, :active=>"true", :page=>0, :per_page=>25}

    expect(@zype.videos.all(params).class).to eq(Zype::Videos)
  end

  it 'get a video' do
    first_video_id = @zype.videos.all({}).first._id

    expect(@zype.videos.find(first_video_id).class).to eq(Zype::Video)
  end

  it 'edit a video' do
    first_video = @zype.videos.all({}).first
    original_title = first_video.title

    first_video.title = original_title + 'NOT'
    first_video.save!

    expect(first_video.title).to_not eq(original_title)
  end

  it 'can create a category' do
    params = {title: 'Bonus Features', values: ['Yes']}
    category_count = @zype.categories.all({}).count

    @zype.categories.create(params)

    expect(@zype.categories.all({}).count).to be(category_count + 1)
  end
end

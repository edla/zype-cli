require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'get first 25 videos' do
    params = {:q=>nil, :type=>nil, :category=>nil, :active=>"true", :page=>0, :per_page=>25}

    expect(@zype.videos.all(params).class).to eq(Zype::Videos)
  end

  it 'find a video' do
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

  it 'can add a zobject' do
    zobject = @zype.zobjects.all('actor', {}).first
    video = @zype.videos.all({}).first

    video.add_zobjects([zobject._id])

    refreshed_video = @zype.videos.all({}).first

    expect(refreshed_video.zobject_ids.include?(zobject._id)).to be true
  end

  it 'can remove a zobject' do
    zobject = @zype.zobjects.all('actor', {}).first
    video = @zype.videos.all({}).first

    video.remove_zobjects([zobject._id])

    refreshed_video = @zype.videos.all({}).first

    expect(refreshed_video.zobject_ids.include?(zobject._id)).to be false
  end


  it 'can create a video'
end

require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 video sources' do
    expect(@zype.video_sources.all({}).class).to eq(Zype::VideoSources)
  end

  it 'can find a video sources' do
    first_video_source = @zype.video_sources.all({}).first

    expect(@zype.video_sources.find(first_video_source._id).class).to eq(Zype::VideoSource)
  end

  it 'can create a video source' do
    video_source_count = @zype.video_sources.all({}).count

    @zype.video_sources.create(guid: '1234abcdefg')

    expect(@zype.video_sources.all({}).count).to eq(video_source_count + 1)
  end
end

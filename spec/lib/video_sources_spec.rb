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

    @zype.video_sources.create('youtube', {guid: 'UCwLr_DYKR8aS0k4r8bB5I5Q', name: 'new grantland'})

    expect(@zype.video_sources.all({}).count).to eq(video_source_count + 1)
  end

  it 'can update a video source' do
    video_source = @zype.video_sources.all({}).last
    original_name = video_source.name

    video_source.name = original_name + 'NOT'
    video_source.save

    refreshed_video_source = @zype.video_sources.all({}).last

    expect(refreshed_video_source.name).to_not eq(original_name)
  end

  it 'can destroy a video source' do
    video_source = @zype.video_sources.all({}).last

    video_source.destroy

    refreshed_video_sources = @zype.video_sources.all({})

    expect(refreshed_video_sources.detect{|v| v['_id'] == video_source._id}).to be nil
  end
end

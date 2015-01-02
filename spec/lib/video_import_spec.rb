require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'get first 25 video imports' do
    params = {:q=>nil, :active=>"true", :page=>0, :per_page=>25}

    expect(@zype.video_imports.all(params).class).to eq(Zype::VideoImports)
  end

  it 'get a video import' do
    video_import_id = @zype.video_imports.all({}).first._id

    expect(@zype.video_imports.find(video_import_id).class).to eq(Zype::VideoImport)
  end

  it 'can add a video import to a new video' do
    video_import = @zype.video_imports.all({}).first
    expect(video_import.video_id).to be nil

    video_import.add_video

    refreshed_video_import = @zype.video_imports.all({}).first

    expect(refreshed_video_import.video_id).to_not be nil
  end

  it 'can add a video import to a preexisting video' do
    video_import = @zype.video_imports.all({}).last
    video = @zype.videos.all({}).first

    expect(video_import.video_id).to be nil
    video_import.add_video(video._id)

    refreshed_video_import = @zype.video_imports.all({}).last

    expect(refreshed_video_import.video_id).to eq(video._id)
  end
end

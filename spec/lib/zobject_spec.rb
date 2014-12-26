require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 zobjects' do
    expect(@zype.zobjects.all('actor', {}).class).to eq(Zype::Zobjects)
  end

  it 'can find a zobject type' do
    first_zobject = @zype.zobjects.all('actor', {}).first

    expect(@zype.zobjects.find('actor', first_zobject._id).class).to eq(Zype::Zobject)
  end

  it 'can create a zobject' do
    zobject_count = @zype.zobjects.all('actor', {}).count

    @zype.zobjects.create('actor', {title: 'Seth Rogen', active: true})

    expect(@zype.zobjects.all('actor', {}).count).to eq(zobject_count + 1)
  end

  it 'can get all the videos of a zobject' do
    first_zobject = @zype.zobjects.all('actor', {}).first

    expect(first_zobject.videos.class).to eq(Zype::Videos)
  end

  it 'can add a video to a zobject' do
    zobject = @zype.zobjects.all('actor', {}).first
    video = @zype.videos.all({}).first

    zobject.add_videos('actor', [video._id])

    refreshed_zobject = @zype.zobjects.all('actor', {}).first

    expect(refreshed_zobject.video_ids.include?(video._id)).to be true
  end

  it 'can remove a video from a zobject' do
    zobject = @zype.zobjects.all('actor', {}).first
    video = @zype.videos.all({}).first

    zobject.remove_videos('actor', [video._id])

    refreshed_zobject = @zype.zobjects.all('actor', {}).first

    expect(refreshed_zobject.video_ids.include?(video._id)).to be false
  end
end

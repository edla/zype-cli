require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 playlists' do
    expect(@zype.playlists.all({}).class).to eq(Zype::Playlists)
  end

  it 'can find a playlist' do
    first_playlist = @zype.playlists.all({}).first

    expect(@zype.playlists.find(first_playlist._id).class).to eq(Zype::Playlist)
  end

  it 'can create a playlist' do
    playlist_count = @zype.playlists.all({}).count

    @zype.playlists.create(title: 'The best active playlist!!', active: true)

    expect(@zype.playlists.all({}).count).to eq(playlist_count + 1)
  end

  it 'can update a playlist' do
    first_playlist = @zype.playlists.all({}).first
    original_title = first_playlist.title

    first_playlist.title = original_title + 'NOT'
    first_playlist.save

    expect(first_playlist.title).to_not eq(original_title)
  end

  it 'can list videos in a playlist' do
    first_playlist = @zype.playlists.all({}).first
    expect(first_playlist.videos.class).to eq(Zype::Videos)
  end

  it 'can destroy a playlist' do
    playlist_count = @zype.playlists.all({}).count
    first_playlist = @zype.playlists.all({}).first

    first_playlist.destroy

    expect(@zype.playlists.all({}).count).to eq(playlist_count - 1)
  end


end

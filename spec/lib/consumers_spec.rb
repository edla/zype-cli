require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 consumers' do
    expect(@zype.consumers.all({}).class).to eq(Zype::Consumers)
  end

  it 'can find a consumer' do
    first_consumer = @zype.consumers.all({}).first

    expect(@zype.consumers.find(first_consumer._id).class).to eq(Zype::Consumer)
  end

  it 'can create a new consumer' do
    consumer_count = @zype.consumers.all({}).count

    @zype.consumers.create(email: 'test@example.com')

    expect(@zype.consumers.count).to eq(consumer_count + 1)
  end

  it 'can update a consumer' do

    @zype.consumers.create(email: 'test1@example.com')
    @zype.consumers.update(consumer._id, email: 'test2@example.com')

    expect(consumer.email).to eq('test2@example.com')
  end

  it 'can favorite a video' do
    video = @zype.videos.all({}).first
    consumer = @zype.consumers.all({}).first

    consumer.favorite_video(video._id)

    expect(consumer.video_favorites.last['video_id']).to eq(video._id)
  end

  it 'can rate a video' do
    video = @zype.videos.all({}).first
    consumer = @zype.consumers.all({}).first
    my_rating = 4

    consumer.rate_video(video._id, rating: my_rating)

    expect(consumer.rate_video(video._id, rating: 4)['response']['rating']).to eq(my_rating)
  end
end

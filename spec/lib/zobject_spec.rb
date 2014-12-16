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
end

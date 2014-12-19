require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 zobject types' do
    expect(@zype.zobject_types.all({}).class).to eq(Zype::ZobjectTypes)
  end

  it 'can find a zobject type' do
    first_z_type = @zype.zobject_types.all({}).first

    expect(@zype.zobject_types.find(first_z_type._id).class).to eq(Zype::ZobjectType)
  end

  it 'can create a zobject type' do
    z_type_count = @zype.zobject_types.all({}).count

    @zype.zobject_types.create(title: 'New Zobject Type!')

    expect(@zype.zobject_types.all({}).count).to eq(z_type_count + 1)
  end
end

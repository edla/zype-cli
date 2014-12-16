require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 devices' do
    expect(@zype.devices.all({}).class).to eq(Zype::Devices)
  end

  it 'can find a device' do
    first_device = @zype.devices.all({}).first

    expect(@zype.devices.find(first_device._id).class).to eq(Zype::Device)
  end
end

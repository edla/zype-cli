require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 device categories' do
    expect(@zype.device_categories.all({}).class).to eq(Zype::DeviceCategories)
  end

  it 'can find a device category' do
    first_device_category = @zype.device_categories.all({}).first

    expect(@zype.device_categories.find(first_device_category._id).class).to eq(Zype::DeviceCategory)
  end
end

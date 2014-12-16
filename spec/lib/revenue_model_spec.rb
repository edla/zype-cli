require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 revenue models' do
    expect(@zype.revenue_models.all({}).class).to eq(Zype::RevenueModels)
  end

  it 'can find a revenue model' do
    first_rm = @zype.revenue_models.all({}).first

    expect(@zype.revenue_models.find(first_rm._id).class).to eq(Zype::RevenueModel)
  end
end

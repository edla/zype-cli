require 'spec_helper'

describe Zype, vcr: true do
  before(:each) do
    @zype = Zype::Client.new
  end

  it 'can list first 25 plans' do
    expect(@zype.plans.all({}).class).to eq(Zype::Plans)
  end

  it 'can find a plan' do
    first_plan = @zype.plans.all({}).first

    expect(@zype.plans.find(first_plan._id).class).to eq(Zype::Plan)
  end
end

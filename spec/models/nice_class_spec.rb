require 'rails_helper'

RSpec.describe NiceClass, type: :model do
  it 'has a valid factory' do
    expect(build(:nice_class)).to be_valid
  end
end

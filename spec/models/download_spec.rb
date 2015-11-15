require 'spec_helper'

describe Raindrops::Download, type: :model do

  before {
    @completed_download = create :download, :completed
  }

  it 'has valid factories' do
    expect(build(:download, :completed)).to be_valid
  end

  context 'when success' do
    it 'should be true' do
      expect(true).to eq true
    end
  end
end

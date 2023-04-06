require 'spec_helper'

RSpec.describe Ship do
  describe '#initialize' do
    it 'exists' do
      cruiser = Ship.new('Cruiser', 3)

      expect(cruiser).to be_a(Ship)
    end
  end
end
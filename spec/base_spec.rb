require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  describe '#number_of_attempts_and_hints' do
    before do
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      app.set_difficulty(app.instance_variable_get(:@game), I18n.t(:easy), 15, 2)
    end

    it 'return true when answer yes' do
      expect(app.instance_variable_get(:@game).number_of_attempts).to eq(15)
      expect(app.instance_variable_get(:@game).attempts_left).to eq(15)
      expect(app.instance_variable_get(:@game).number_of_hints).to eq(2)
      expect(app.instance_variable_get(:@game).hints_left).to eq(2)
    end
  end
end

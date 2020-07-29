require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  describe 'registration' do
    let(:invalid_name) { 'A' }
    let(:valid_name) { 'Bob' }

    before do
      allow(STDOUT).to receive(:puts)
      allow(app).to receive(:loop).and_yield # to simulate one tick of the loop
    end

    it 'prints message about the invalid name' do
      allow($stdin).to receive(:gets).and_return(invalid_name)
      app.reg(app.instance_variable_get(:@game))
      expect(STDOUT).to have_received(:puts).with I18n.t(:not_available_name)
    end

    it 'returns new user and difficulty' do
      allow($stdin).to receive(:gets).and_return(valid_name)
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      app.reg(app.instance_variable_get(:@game))
      game = app.instance_variable_get(:@game)
      expect(game.user).to eq(valid_name)
    end
  end
end

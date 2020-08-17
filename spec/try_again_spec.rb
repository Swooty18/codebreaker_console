require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  describe '#try_again' do
    before do
      allow(STDOUT).to receive(:puts)
      allow(app).to receive(:loop).and_yield # to simulate one tick of the loop
    end

    it 'return true when answer yes' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:yes))
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      expect(app.try_again).to be_truthy
    end

    it 'return false when answer no' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:no))
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      expect(app.try_again).to be_falsey
    end

    it 'start new game when answer yes' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:yes))
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      app.try_again
      expect(app.instance_variable_get(:@game)).not_to be_nil
    end

    it 'shows bye message' do
      allow($stdin).to receive(:gets).and_return('I18n.t(:no)', I18n.t(:no))
      app.instance_variable_set(:@game, Codebreaker::Game.new)
      app.try_again
      expect(STDOUT).to have_received(:puts).with I18n.t(:bye_message)
    end
  end
end

require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  describe 'difficulty' do
    before do
      allow(STDOUT).to receive(:puts)
      allow(app).to receive(:loop).and_yield # to simulate one tick of the loop
    end

    it 'difficulty should be easy' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:easy))
      app.run
      app.select_difficulty(app.instance_variable_get(:@game))
      expect(app.instance_variable_get(:@game).difficulty).to eq(I18n.t(:easy))
    end

    it 'difficulty should be medium' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:medium))
      app.run
      app.select_difficulty(app.instance_variable_get(:@game))
      expect(app.instance_variable_get(:@game).difficulty).to eq(I18n.t(:medium))
    end

    it 'difficulty should be hell' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:hell))
      app.run
      app.select_difficulty(app.instance_variable_get(:@game))
      expect(app.instance_variable_get(:@game).difficulty).to eq(I18n.t(:hell))
    end

    it 'unexpected difficulty' do
      allow($stdin).to receive(:gets).and_return('top')
      app.run
      app.select_difficulty(app.instance_variable_get(:@game))
      expect(STDOUT).to have_received(:puts).with I18n.t(:cannot_comprehend)
    end
  end
end

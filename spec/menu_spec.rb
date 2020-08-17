require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  describe '#menu' do
    before do
      allow(STDOUT).to receive(:puts)
      allow(app).to receive(:loop).and_yield # to simulate one tick of the loop
    end

    it 'starts game and exit' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:start), 'Ivan', I18n.t(:easy), I18n.t(:exit))
      expect { app.run }.to raise_error(Codebreaker::Exceptions::TerminateError)
    end

    it 'shows rules' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:rules))
      app.run
      expect(STDOUT).to have_received(:puts).with I18n.t(:rules_text)
    end

    it 'shows stats' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:stats))
      app.run
    end

    it 'unexpecteds command' do
      allow($stdin).to receive(:gets).and_return('startttttt')
      app.run
      expect(STDOUT).to have_received(:puts).with I18n.t(:unexpected_command)
    end
  end
end

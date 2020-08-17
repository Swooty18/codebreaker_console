require 'spec_helper'

RSpec.describe Application do
  subject(:app) { described_class.new }

  let(:game) { Codebreaker::Game.new }

  describe '#menu' do
    before do
      allow(STDOUT).to receive(:puts)
    end

    context 'with secret code 4444' do
      before do
        allow(game).to receive(:generate_secret_code)
        game.instance_variable_set(:@secret_code, '4444')
        game.start
      end

      it 'starts game and win' do
        allow($stdin).to receive(:gets).and_return('Ivan', I18n.t(:easy), '4444', 'так', I18n.t(:exit))
        app.instance_variable_set(:@game, game)
        expect { app.start_game }.to raise_error(Codebreaker::Exceptions::TerminateError)
        game = app.instance_variable_get(:@game)
        expect(game.status).to eq(:won)
      end

      it 'starts game and puts marks' do
        allow($stdin).to receive(:gets).and_return('Ivan', I18n.t(:easy), '4422', I18n.t(:exit))
        app.instance_variable_set(:@game, game)
        expect { app.start_game }.to raise_error(Codebreaker::Exceptions::TerminateError)
        expect(STDOUT).to have_received(:puts).with '++'
      end

      it 'starts game and puts hint' do
        allow($stdin).to receive(:gets).and_return('Ivan', I18n.t(:easy), I18n.t(:hint), I18n.t(:exit))
        app.instance_variable_set(:@game, game)
        expect { app.start_game }.to raise_error(Codebreaker::Exceptions::TerminateError)
        expect(STDOUT).to have_received(:puts).with '4'
      end
    end

    context 'with 0 attempts' do
      before do
        allow(game).to receive(:attempts_available?)
        game.instance_variable_set(:@attempts_left, 0)
      end

      it 'starts game and lose' do
        allow($stdin).to receive(:gets).and_return('Ivan', I18n.t(:easy), '4444', '4444', I18n.t(:exit))
        game.start
        app.instance_variable_set(:@game, game)
        expect { app.start_game }.to raise_error(Codebreaker::Exceptions::TerminateError)
      end
    end

    context 'with 0 hints' do
      before do
        allow(game).to receive(:hint!)
        game.instance_variable_set(:@hints_left, 0)
      end

      it 'starts game and have not hint' do
        allow($stdin).to receive(:gets).and_return('Ivan', I18n.t(:easy), I18n.t(:hint), I18n.t(:exit))
        game.start
        app.instance_variable_set(:@game, game)
        expect { app.start_game }.to raise_error(Codebreaker::Exceptions::TerminateError)
        expect(STDOUT).to have_received(:puts).with I18n.t(:out_hints)
      end
    end

    it 'starts game and puts cannot_comprehend' do
      allow($stdin).to receive(:gets).and_return(I18n.t(:start), 'Ivan', I18n.t(:easy), 'I18n.t(:hint)', I18n.t(:exit))
      expect { app.run }.to raise_error(Codebreaker::Exceptions::TerminateError)
      expect(STDOUT).to have_received(:puts).with I18n.t(:cannot_comprehend)
    end
  end
end

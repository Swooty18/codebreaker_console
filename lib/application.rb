# frozen_string_literal: true

# Console application.
# Should be pushed into the other gem in the future!
class Application
  CODE_RANGE_MIN = Codebreaker::Game::CODE_RANGE_MIN
  CODE_RANGE_MAX = Codebreaker::Game::CODE_RANGE_MAX
  COUNT_OF_NUMBER = Codebreaker::Game::COUNT_OF_NUMBER
  FILESTAT = './stat.yml'

  include Registration
  include Difficulty
  def run
    @game = Codebreaker::Game.new
    puts I18n.t(:welcome)
    loop do
      puts I18n.t(:main_menu)
      input = $stdin.gets.chomp
      menu(input)
    end
  end

  def menu(input)
    check_on_exit(input)
    case input
    when I18n.t(:start) then @game.start; start_game
    when I18n.t(:rules) then puts I18n.t(:rules_text)
    when I18n.t(:stats) then puts stat
    else
      puts I18n.t(:unexpected_command)
    end
  end

  def try_again
    puts I18n.t(:again)
    input = $stdin.gets.chomp
    check_on_exit(input)
    if input == I18n.t(:yes)
      @game.start
      case_diff(@game, @game.difficulty) || true
    elsif input == I18n.t(:no)
      (puts I18n.t(:bye_message)) && false
    else try_again
    end
  end

  def start_game
    reg(@game)
    select_difficulty(@game)
    loop do
      unless @game.attempts_available?
        print I18n.t(:secret_code)
        puts @game.secret_code
        break unless try_again
      end
      game_progress
    end
  end

  def select_difficulty(game)
    loop do
      print I18n.t(:select_difficulty)
      diff = $stdin.gets.chomp
      check_on_exit(diff)
      break if (case_diff(game, diff))
    end
  end

  def game_progress
    print I18n.t(:guess)
    input = $stdin.gets.chomp
    check_on_exit(input)
    case input
    when I18n.t(:hint) then puts @game.hint! || I18n.t(:out_hints)
    when /^([#{CODE_RANGE_MIN}-#{CODE_RANGE_MAX}]{#{COUNT_OF_NUMBER}})$/
      one_guess(@game.guess(Regexp.last_match(1)))
    else
      puts I18n.t(:cannot_comprehend)
    end
  end

  def one_guess(win_guess)
    if win_guess
      puts I18n.t(:won)
      puts I18n.t(:save_result?)
      if $stdin.gets.chomp == I18n.t(:yes)
        @game.save_stat_in_file(FILESTAT, @game.stats_hash)
      end
    else
      puts @game.marks
    end
  end

  def stat
    records = Psych.load_stream(File.open(FILESTAT))
    records.sort_by { |record| [record[:attempts], record[:attempts_used], record[:hints_used]] }
  end

  def check_on_exit(name)
    if name == I18n.t(:exit)
      puts I18n.t(:bye_message)

      raise Codebreaker::Exceptions::TerminateError
    end
  end
end

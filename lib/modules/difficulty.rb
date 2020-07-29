module Difficulty
  def select_difficulty(game)
    loop do
      print I18n.t(:select_difficulty)
      diff = $stdin.gets.chomp
      check_on_exit(diff)
      break if (case_diff(game, diff))
    end
  end

  def set_difficulty(game, diff, attempts, hints)
    game.number_of_attempts = @game.attempts_left = attempts
    game.number_of_hints = @game.hints_left = hints
    game.difficulty = diff
  end

  def case_diff(game, diff)
    case diff
    when I18n.t(:easy) then set_difficulty(game, diff, 15, 2); true
    when I18n.t(:medium) then set_difficulty(game, diff, 10, 1); true
    when I18n.t(:hell) then set_difficulty(game, diff, 5, 1); true
    else puts I18n.t(:cannot_comprehend); false
    end
  end
end

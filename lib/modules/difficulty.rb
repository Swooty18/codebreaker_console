module Difficulty
  def case_diff(game, diff)
    case diff
    when I18n.t(:easy) then game.set_difficulty(diff, 15, 2); true
    when I18n.t(:medium) then game.set_difficulty(diff, 10, 1); true
    when I18n.t(:hell) then game.set_difficulty(diff, 5, 1); true
    else puts I18n.t(:cannot_comprehend); false
    end
  end
end

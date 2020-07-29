module Registration
  NAME_MIN_LENGHT = 3
  NAME_MAX_LENGHT = 21
  def reg(game)
    loop do
      print I18n.t(:enter_name)
      user_name = $stdin.gets.chomp
      check_on_exit(user_name)
      if user_name.instance_of?(String) && user_name.length >= NAME_MIN_LENGHT && user_name.length <= NAME_MAX_LENGHT
        game.user = user_name; break
      else
        puts I18n.t(:not_available_name)
      end
    end
  end
end

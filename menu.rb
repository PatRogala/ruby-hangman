require_relative 'hangman'

class Menu
  @@saves = Dir["./saves/*.save"]

  def self.open
    print_menu
    choose_option
  end

  def self.print_menu
    puts ''.rjust(24, '-')
    puts 'H A N G M A N'.center(24)
    puts '   M A I N   M E N U'.ljust(24)
    puts "\n\n"
    puts ' 1. S T A R T  N E W  G A M E'
    puts ' 2. S A V E S'
    puts "\n"
    puts ' 3. E X I T'
    puts "\n\n"
    puts ''.rjust(24, '-')
  end

  def self.print_saves
    system 'clear'
    puts ''.rjust(24, '-')
    puts 'H A N G M A N'.center(24)
    puts "\n\n"
    puts ' S A V E S'.ljust(24)
    puts "\n\n"
    @@saves.each_with_index do |save, idx|
      savefile = save.split('/')
      savename = savefile[2].split('.')
      puts " " + idx.to_s + " #{savename[0]}"
    end
    puts "\n\n"
    puts ' b  B A C K'
    puts "\n\n"
    puts ''.rjust(24, '-')
  end

  def self.choose_save
    option = gets.chomp
    case option
    when 'b'
      system 'clear'
      Menu.open
    else
      option = option.to_i
      if option < @@saves.size && option >= 0
        game = Hangman.new("game")
        game.load_game(@@saves[option])
      else
        system 'clear'
        print_saves
        choose_save
      end
    end
  end

  def self.choose_option
    option = gets.chomp.to_i

    case option
    when 1
      dictionary = File.open('dict.txt', 'r')
      words = dictionary.read.split
      random_word = words.sample
      random_word = words.sample until random_word.length.between?(5, 12)
      dictionary.close
      game = Hangman.new(random_word)
      game.start
    when 2
      print_saves
      choose_save
    when 3
      system 'clear'
      exit
    else
      system 'clear'
      print_menu
      choose_option
    end
  end
end
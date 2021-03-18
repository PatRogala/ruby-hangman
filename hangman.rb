require 'yaml'
require_relative 'helper'
require_relative 'menu'

class Hangman
  def initialize(word)
    @secret_word = word.downcase
    @chances = 6
    @guess = Array.new(@secret_word.length, '_')
    @incorrect_guesses = []
  end

  def load_game(name)
    save = File.open("#{name}", 'r')
    game = YAML.load(save)
    game.start
  end

  def save_game(name)
    save = File.open("./saves/#{name}.save", 'w')
    save.write(YAML.dump(self))
    save.close
  end

  def correct_guess?(letter)
    return true if letter == 'save'
    return false if @incorrect_guesses.include?(letter)
    return false if letter.length > 1
    return false unless letter?(letter)
    return false if @guess.include?(letter)

    true
  end

  def make_guess(letter)
    if letter == 'save'
      print "Save name: "
      name = gets.chomp
      save_game(name)
      Menu.open
    end
    if @secret_word.include?(letter)
      idx = []
      @secret_word.each_char.with_index do |char, indx|
        idx << indx if char == letter
      end
      idx.each do |indx|
        @guess[indx] = letter
      end
    else
      @chances -= 1
      @incorrect_guesses << letter
    end
  end

  def print_board
    puts ''.ljust(32, '-')
    puts "\n\n"
    puts @guess.join(' ').center(32)
    puts "\n\n"
    puts ' Chances left:' + ' O ' * @chances
    puts ' Incorrect guesses: ' + @incorrect_guesses.join(' ')
    puts ''.ljust(32, '-')
  end

  def win?
    return true unless @guess.include?('_')
    false
  end

  def play_round
    print_board
    print 'Letter: '
    letter = gets.chomp.downcase
    if !correct_guess?(letter)
      system "clear"
      puts "Provide correct guess!"
    else
      system "clear"
      make_guess(letter)
    end
    if win?
      puts "You won! Word: #{@secret_word}" if win?
      Menu.open
    end
  end

  def start
    system "clear"
    play_round until @chances.zero?
    puts "You lost! Word: #{@secret_word}"
    Menu.open
  end
end

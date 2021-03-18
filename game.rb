require_relative 'hangman'
require_relative 'menu'


dictionary = File.open('dict.txt', 'r')
words = dictionary.read.split
random_word = words.sample
random_word = words.sample until random_word.length.between?(5, 12)

Menu.open

#game = Hangman.new(random_word)
#game.start

# Require elements that we need


# Classes: User?, Game
# Modules: WordGenerator

# On Load:
# Load saved game? Y / N
# Load saved_game file if there is one otherwise, output message
# and make them start a new one

# Load Dictionary
# Limit to words between 5-12 charactors
# Pick random word

# Display Stick figure associated with count of guesses missed
# and count of guesses left (6 total before lose)

"
_______
|     |
|     O     
|    /|\
|    / \  
|
-------------
"

# Also display the letters that were wrong
# Also display blanks and correct letters


# Gameplay
# Player guesses a letter
# Display board and Win message if they won, otherwise new guess

# At start of guess, player can choose the option to save instead
# Serialize the game class so it can be loaded!

Module WordGenerator
  words = File.open('5desk.txt')
  filtered_words = words.readlines.select { |word|
    word.length.between?(5..12)
  }.downcase!
  def generate_word(filtered_words)
    word = filtered_words[rand(filtered_words.length-1).floor]
    return word
  end
end

class Hangman
  def load_game
    puts "Would you like to load a saved game?"
    if gets.chomp.downcase == 'y'
      if File.exist? "saved_game.txt"
        game_file = File.open("saved_game.txt", 'r')
      else
        puts "No game saved :(. Let's start a new game!"
      end
    else
      "New game starting!"
      new_game
      hangman.play_game
    end
  end
  def new_game
    hangman = Game.new
  end
end


class Game

  def initialize
    @guesses = 0
    @word 
  end

  def play_game
  
  end


end
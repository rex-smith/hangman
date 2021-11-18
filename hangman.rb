require 'json'
# On Load:
# Load saved game? Y / N
# Load saved_game file if there is one otherwise, output message
# and make them start a new one

# At start of guess, player can choose the option to save instead
# Serialize the game class so it can be loaded!

module WordGenerator
  @file = File.open('5desk.txt', 'r')
  @words = @file.readlines.map {|line| line[..-3]}
  @filtered_words = @words.select { |word| word.length.between?(5,12)}
  def self.generate_word
    @word = @filtered_words[rand(@filtered_words.length-1).floor]
    return @word.downcase
  end
end

class Hangman

  def load_game
    puts "Would you like to load a saved game?"
    if gets.chomp.downcase == 'y'
      if File.exist? "saved_game.txt"
        @game_file = File.open("saved_game.txt", 'r')
        @hangman = Game.from_json(@game_file)
      else
        puts "No game saved :(. Let's start a new game!"
        puts "New game starting!"
        new_game
      end
    else 
      "New game starting!"
      new_game
    end
  end

  def new_game
    @hangman = Game.new
    return @hangman
  end

end


class Game

  include WordGenerator

  def initialize(guesses=[], word=WordGenerator.generate_word, guesses_left=6,
    board = Array.new(@word.length, "_"), good_guess = false, game_over = false)
    @guesses = guesses
    @word = word
    @guesses_left = guesses_left
    @board = board
    @good_guess = good_guess
    @game_over = game_over
  end

  def play_game
    while @guesses_left > 0
      print_game_status
      @new_guess = ask_for_guess
      handle_guess(@new_guess)
      if @game_over == true
        return
      end
    end
    if @guesses_left == 0
      lose_game
    else
      return
    end
  end

  def ask_for_guess
    @good_guess = false
    puts "Please guess a letter or enter 'save'. #{@guesses_left} guess(es) remaining."
    @guess = gets.chomp.downcase
    if @guess == 'save'
      save_game
    end
    until isLetter?(@guess)
      ask_for_guess
    end
    return @guess
  end

  def isLetter?(char)
    char.match?(/[[:alpha:]]/) && char.length == 1
  end

  def handle_guess(guess)
    @guesses.push(guess)
    @word.split("").each_with_index do |letter, index| 
      if letter == guess
        @good_guess = true
        @board[index] = guess
      end
    end

    if @good_guess == false
      @guesses_left -= 1
    end

    if @board == @word.split('')
      win_game
    end

  end

  def lose_game
    print_man
    print_guesses
    puts ""
    puts "You lost the game!"
    print_word
    puts @word.split("").join(" ")
  end

  def win_game
    print_man
    print_guesses
    print_word
    puts "You won the game!"
    @game_over = true
  end

  def print_game_status
    print_man
    print_guesses
    puts ""
    print_word
  end

  def print_man

    @bodypart_1 = @guesses_left < 6 ? "O" : " "
    @bodypart_2 = @guesses_left < 5 ? "|" : " "
    @bodypart_3 = @guesses_left < 4 ? "/" : " "
    @bodypart_4 = @guesses_left < 3 ? "\\" : " "
    @bodypart_5 = @guesses_left < 2 ? "\\" : " "
    @bodypart_6 = @guesses_left < 1 ? "/" : " "

    man = "
    _______
    |     |
    |     #{@bodypart_1}     
    |    #{@bodypart_6}#{@bodypart_2}#{@bodypart_5}
    |    #{@bodypart_3} #{@bodypart_4}  
    |
    -------------
    "

    puts man
  end

  def print_word
    puts @board.join(" ")
  end

  def print_guesses
    puts "Guesses: #{@guesses.join(" - ")}"
  end

  def to_json
    JSON.dump ({
      :guesses => @guesses,
      :word => @word,
      :guesses_left => @guesses_left,
      :board => @board,
      :good_guess => @good_guess,
      :game_over => @game_over
    })
  end

  def self.from_json(string)
    data = JSON.load string
    self.new(data['guesses'], data['word'], data['guesses_left'], data['board'],
    data['good_guess'], data['game_over'])
  end

  def save_game
    saved_game = File.open("saved_game.txt", 'w')
    saved_game.puts self.to_json
    saved_game.close
    abort("Game saved!")
  end

end

# Here is where the game is actually started and played

hangman = Hangman.new
current_game = hangman.load_game
current_game.play_game


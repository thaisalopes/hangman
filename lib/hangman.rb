require "yaml"

class Game

  def initialize
    @word = ""
    @guess = ""
    @used_letters = []
    @correct_letters = []
    @incorrect_letters = []
    @victory = false
    @game_player = Player.new
    @lives_left = 6
    full_game
  end

  def full_game
    choose_word
    @game_board = Board.new(@word)
    rounds
  end

  def save_game
    serialized = YAML.dump(self)
    File.write("hangman_save.yaml", serialized)
  end

  def self.load_game
    file = File.read("hangman_save.yaml")
    game = YAML.load(file)
    game.rounds
  end

  def rounds
    while @victory == false && @lives_left.positive?
      puts "\nWould you like to save your game now? (Y/N)"
      reply = gets.chomp.downcase
      if reply == "y"
        save_game
      end
      puts "\nYou have #{@lives_left} lives left."
      @guess = @game_player.make_guess(@used_letters)
      @used_letters.push(@guess)
      check_correct_letters
      @incorrect_letters = @used_letters - @correct_letters
      puts "\nCorrectly guessed: #{@correct_letters.join(", ")}"
      puts "Incorrect guesses: #{@incorrect_letters.join(", ")}\n"
      check_included
      @victory = @game_board.check_victory
      if @victory == true
        puts "\nCongratulations, you won!"
      else
      check_lives_left
        if @lives_left == 0
          puts "\nOUCH, you're dead :("
        end
      end
    end
  end


  def choose_word
    dictionary = []
    File.foreach('google-10000-english-no-swears.txt') do |line|
      dictionary.push(line)
    end
    @word = dictionary[rand 0..dictionary.length+1].chomp
    if @word.length > 12
      choose_word
    elsif @word.length < 5
      choose_word
    else
      puts "The word is: #{@word}"
    end
  end

  def check_included
    word_array = @word.split('')
    word_array.each_with_index do |letter,index|
      new_index = index*2 
      if letter == @guess
        @game_board.write_on_board(letter,new_index)
      end
    end
    @game_board.show_game_board
    return @game_board
  end

  def check_correct_letters
    @word.include?(@guess) ? @correct_letters.push(@guess) : false
  end

  def check_lives_left
    @lives_left = 6 - @incorrect_letters.length
  end
end

class Player
  def initialize
    @guess = ""
  end

  def make_guess (used_letters)
    @used_letters = used_letters
    puts "\nMake your guess\n"
    @guess = gets.chomp.downcase
    if @guess.length > 1
      puts "You should choose one letter only\n"
      make_guess(@used_letters)
    elsif used_letters.include?(@guess)
      puts "You have already tried this letter, try another one\n"
      make_guess(@used_letters)
    else
      @guess
    end
  end
end 

class Board
  def initialize (word)
    @board = ""
    create_board(word)
  end

  def create_board(word)
    space = "_ "
    letter_number = 0
    number_of_spaces = word.length
    while letter_number < number_of_spaces
      @board += space
      letter_number += 1
    end
    puts @board
  end

  def write_on_board(letter,index)
    board_array = @board.split('')
    board_array[index] = letter
    @board = board_array.join
    return @board
  end

  def show_game_board
    puts @board
  end

  def check_victory
    if @board.split('').all? { |space| space != "_"}
      victory = true
    else
      victory = false
    end
    victory
  end
end


if File.exist?("hangman_save.yaml")
  puts "Would you like to load a saved game? (Y/N)"
  answer = gets.chomp.downcase
    if answer == "y"
      Game.load_game
    else
      Game.new
    end
end
class Game

  def initialize
    @dictionary = []
    @word = ""
    @guess = ""
    @used_letters = []
    @victory = false
    @game_board =""
    @game_player = Player.new
    full_game
  end

  def full_game
    choose_word
    @game_board = Board.new(@word)
    rounds
  end

  def rounds
    round_number = 0
    while @victory == false && round_number<= 10
      @guess = @game_player.make_guess
      @used_letters.push(@guess)
      check_included
      puts "You have already tried these letters: #{@used_letters}"
      round_number+=1
    end
  end


  def choose_word  
    File.foreach('google-10000-english-no-swears.txt') do |line|
      @dictionary.push(line)
    end
    @word = @dictionary[rand 0..@dictionary.length+1].chomp
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
      else
        @game_board.show_game_board
      end
    return @game_board
    end
  end
end

class Player
  def initialize
    @guess = ""
  end

  def make_guess
    puts "Make your guess"
    @guess = gets.chomp
    if @guess.length > 1
      puts "You should choose one letter only"
      make_guess
    else
      puts "Your guess is #{@guess}"
      return @guess
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
    puts @board
    return @board
  end

  def show_game_board
    puts @board
  end
end

Game.new
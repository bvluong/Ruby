require_relative 'player.rb'
require 'byebug'

class Game
  attr_accessor :board, :player1, :player2

  def initialize(board = Board.new)
    @board = board
    @player1 = HumanPlayer.new(board,:X)
    @player2 = ComputerPlayer.new(board,:O)
    @current_player = @player1
  end

  def current_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end

  def setup
    until game_over?
      play_turn
      return puts "You have won" if @board.won?(@current_player.mark)
      current_player
    end
    puts "Draw, No more possible moves"
  end

  def play_turn
    display
    move = @current_player.get_move
    @board.place_mark(move,@current_player.mark)
  end

  def display
    @board.display
  end

  def game_over?
    @board.full?
  end

end

class Board
attr_accessor :board
Hashkey = {:X => "X", :O => "O", nil => "_"}

  def initialize(board = Array.new(3) {Array.new(3)})
    @board = board
  end

  def []=(pos,val)
    row,col = pos
    board[row][col] = val
  end

  def place_mark(pos,mark)
    self[pos] = mark
  end

  def [](pos)
    row,col = pos
    board[row][col]
  end

  def empty?(pos)
    self[pos].nil?
  end

  def columns
    columns = Array.new(3) {Array.new}
    @board.each do |x|
      x.each_index {|y| columns[y] << x[y]}
    end
    columns
  end

  def diagonals
    down_diag = [[0, 0], [1, 1], [2, 2]]
    up_diag = [[0, 2], [1, 1], [2, 0]]

    [down_diag, up_diag].map do |diag|
      diag.map { |row, col| @board[row][col] }
    end
  end

  def full?
    @board.each.all? {|x| !x.include? nil}
  end

  def all_arrays
    @board + diagonals + columns
  end

  def won?(mark)
    all_arrays.each {|x| return true if x.count(mark) == 3}
    false
  end

  def display_board
    @board.map do |x|
      x.map {|y| Hashkey[y]}
    end
  end


  def won_a_row(player)
    @board.any? { |row| row.all? {|entry| entry == player } }
  end
  
  def won_a_column(player)
    @board.transpose.any? { |row| row.all? {|entry| entry == player } }
  end 

  def display
    p display_board
    puts "  O 1 2"
    display_board.each.with_index do |x,y|
      puts "#{y} #{x[0]} #{x[1]} #{x[2]}"
    end
  end
  
end

if __FILE__ == $PROGRAM_NAME
  Game.new.setup
end

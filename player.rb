require 'byebug'

class ComputerPlayer
  attr_accessor :board, :mark

  def initialize(board = Board.new,mark = :X)
    @board = board
    @mark = mark
  end
  
  def get_move
    if win?
      win?
    elsif win?(opponent_mark)
      win?(opponent_mark)
    else
      random
    end
  end
  
  def opponent_mark
    if @mark== :X
      :O
    else
      :X
    end
  end
  
  def possible_moves
    moves = Array.new
    (0..2).step do |x|
      (0..2).step {|y| moves << [x,y] if @board.empty?([x,y]) }
    end
    moves.compact
  end
  
  
  def win?(mark = @mark)
    moves = possible_moves
    moves.each do |x|
      @board.place_mark(x,mark)
      if @board.won?(mark)
        @board[x] = nil
        return x
      else
        @board[x] = nil
      end
    end
    false
  end
  
  def random
    possible_moves.sample  
  end
  
end
    
    
class HumanPlayer
  attr_accessor :board, :mark

  def initialize(board = Board.new,mark = :X)
    @board = board
    @mark = mark
  end

  def get_move
    puts "What is your move?"
    begin
      move = translate(gets.chomp)
      until @board.empty?(move)
        puts "Invalid move, please pick a new pos"
        move = translate(gets.chomp)
      end
    rescue
      puts "Incorrect format, please try again"
      retry
    end
    move
  end

  def translate(move)
    move.split(",").map {|x| x.to_i }
  end

end
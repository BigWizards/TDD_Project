module Connect4
  class Chip 
    attr_accessor :value
    
    def initialize(player)
      change_value(player)
    end

    def change_value(player)
      if player == 1
        @value = "R"
      else
        @value = "B"
      end
    end
  end

  class BoardSpace
    attr_reader :value

    def initialize
      @value = " "
    end
  end

  class Player
    attr_reader :identity, :move, :cells_owned
    @@posible_moves = [1, 2, 3, 4, 5, 6, 7]

    def initialize(identity)
      @identity = identity
      @cells_owned = []
    end

    def get_move
      input = gets.to_i
      if @@posible_moves.include?(input) == false
        puts "Please enter a column for your move, such as 1, 2, 3, etc."
        self.get_move
      else
        @move = input
        @cells_owned << input
      end
    end
  end

  class Board
    attr_reader :board, :print_board, :cells, :full_column
    
    def initialize
      @cells = []
      @print_cells = []
      @full_column = []
      self.build_board
      self.fill_print_board
    end

    def build_board
      9.times { @cells << [] }
    end

    def fill_print_board
      7.times do
        column = []
        6.times do
          column << BoardSpace.new
        end
        @print_cells << column
      end
    end

    def replace_print_space(column, chip)
      first_slot = @print_cells[column].index { |space| space.value == " " }
      @print_cells[column][first_slot] = chip
    end

    def add_chip(player)
      if full_column.include?(player.move) 
        return "Column full" 
      end 
      case player.move
      when 1
        @cells[0] << Chip.new(player.identity)
        replace_print_space(0, cells[0][-1])
        full_column << 1 if @cells[0].length == 6
      when 2
        @cells[1] << Chip.new(player.identity)
        replace_print_space(1, cells[1][-1])
        full_column << 2 if @cells[1].length == 6 
      when 3
        @cells[2] << Chip.new(player.identity)
        replace_print_space(2, cells[2][-1])
        full_column << 3 if @cells[2].length == 6
      when 4
        @cells[3] << Chip.new(player.identity)
        replace_print_space(3, cells[3][-1])
        full_column << 4 if @cells[3].length == 6
      when 5
        @cells[4] << Chip.new(player.identity)
        replace_print_space(4, cells[4][-1])
        full_column << 5 if @cells[4].length == 6
      when 6
        @cells[5] << Chip.new(player.identity)
        replace_print_space(5, cells[5][-1])
        full_column << 6 if @cells[5].length == 6
      when 7
        @cells[6] << Chip.new(player.identity)
        replace_print_space(6, cells[6][-1])
        full_column << 7 if @cells[6].length == 6
      else
        "Invalid move"
      end
    end

    def print_board
      "      |---|---|---|---|---|---|---|
      | #{@print_cells[0][5].value} | #{@print_cells[1][5].value} | #{@print_cells[2][5].value} | #{@print_cells[3][5].value} | #{@print_cells[4][5].value} | #{@print_cells[5][5].value} | #{@print_cells[6][5].value} | 
      |---|---|---|---|---|---|---|
      | #{@print_cells[0][4].value} | #{@print_cells[1][4].value} | #{@print_cells[2][4].value} | #{@print_cells[3][4].value} | #{@print_cells[4][4].value} | #{@print_cells[5][4].value} | #{@print_cells[6][4].value} |
      |---|---|---|---|---|---|---|
      | #{@print_cells[0][3].value} | #{@print_cells[1][3].value} | #{@print_cells[2][3].value} | #{@print_cells[3][3].value} | #{@print_cells[4][3].value} | #{@print_cells[5][3].value} | #{@print_cells[6][3].value} |
      |---|---|---|---|---|---|---|
      | #{@print_cells[0][2].value} | #{@print_cells[1][2].value} | #{@print_cells[2][2].value} | #{@print_cells[3][2].value} | #{@print_cells[4][2].value} | #{@print_cells[5][2].value} | #{@print_cells[6][2].value} |
      |---|---|---|---|---|---|---|
      | #{@print_cells[0][1].value} | #{@print_cells[1][1].value} | #{@print_cells[2][1].value} | #{@print_cells[3][1].value} | #{@print_cells[4][1].value} | #{@print_cells[5][1].value} | #{@print_cells[6][1].value} |
      |---|---|---|---|---|---|---|
      | #{@print_cells[0][0].value} | #{@print_cells[1][0].value} | #{@print_cells[2][0].value} | #{@print_cells[3][0].value} | #{@print_cells[4][0].value} | #{@print_cells[5][0].value} | #{@print_cells[6][0].value} |
      |---|---|---|---|---|---|---|
        1   2   3   4   5   6   7"
    end
  end

  class Game
    attr_accessor :board, :player1, :player2, :game_over

    def initialize(board, player1, player2)
      @board = board
      @player1 = player1
      @player2 = player2
    end

    def turn
      puts "Player 1 make your move"
      @player1.get_move
      @board.add_chip(@player1)
      puts @board.print_board
      return puts"Player 1 WINS!" if win?(player1)
      puts "Player 2 make your move"
      @player2.get_move
      @board.add_chip(@player2)
      puts @board.print_board
      return puts"Player 2 WINS!" if win?(player2)
    end

    def win?(player)
      if self.vertical_win? || self.horizontal_win? || self.diagonal_win?(player)
        @game_over = true
        true
      else
        false
      end 
    end

    def winning_combination?(array)
      red_chips = 0
      blue_chips = 0
      array.each do |chip|
        if chip.nil?
          red_chips = 0
          blue_chips = 0
          next
        end
        case chip.value
        when "R"
          red_chips += 1
          blue_chips = 0 
        when "B"
          blue_chips += 1
          red_chips = 0 
        end
        if red_chips == 4
          @winner = "Player 1"
          return true
        elsif blue_chips == 4
          @winner = "Player 2"
          return true
        end
      end
      return false
    end


    def vertical_win?
      @board.cells.each do |column|
         return true if winning_combination?(column)
      end
      return false
    end

    def horizontal_win?
      current_row = 0
      cell_row = [] 
      columns = [0, 1, 2, 3, 4, 5, 6]
      columns.each { |column| cell_row << @board.cells[column][current_row] }
      until current_row == 7
        return true if winning_combination?(cell_row)
        cell_row = []
        current_row += 1
        if current_row < 8
          columns.each { |column| cell_row << @board.cells[column][current_row] }
        end
      end
      return false
    end


    def diagonal_search(player_move_adjusted, last_chip, direction)
      possible_chips = [@board.cells[player_move_adjusted][last_chip]]
      queue = []
      directions = [[2, 2], [-2, -2], [2, -2], [-2, 2]]
      directions_index = direction == "forward" ? 0 : 2
      
      2.times do 
        case directions_index
        when 0
          queue << @board.cells[player_move_adjusted + 1][last_chip + 1] if player_move_adjusted < 6
        when 1
          queue << @board.cells[player_move_adjusted - 1][last_chip - 1]
        when 2
          queue << @board.cells[player_move_adjusted + 1][last_chip - 1] if player_move_adjusted < 6
        when 3
          queue << @board.cells[player_move_adjusted - 1][last_chip + 1]
        end
        until queue.empty?
          if queue[0].nil?
            queue.shift
            next
          end
          possible_chips << queue[0]
          queue.shift
          queue << @board.cells[player_move_adjusted + directions[directions_index][0]][last_chip + directions[directions_index][1]]
          if directions[directions_index][0] >= 1 
            directions[directions_index][0] += 1 
          else
            directions[directions_index][0] -= 1
          end
          if directions[directions_index][1] >= 1
            directions[directions_index][1] += 1 
          else
            directions[directions_index][1] -= 1
          end
        end
        directions_index += 1
      end
      
      return possible_chips
    end

    def diagonal_win?(player)
      player_move_adjusted = player.move - 1
      last_chip = @board.cells[player_move_adjusted].length - 1
      return true if winning_combination?(diagonal_search(player_move_adjusted, last_chip, "forward"))
      return true if winning_combination?(diagonal_search(player_move_adjusted, last_chip, "reverse"))
      return false
    end
  end
end

board = Connect4::Board.new 
player1 = Connect4::Player.new(1)
player2 = Connect4::Player.new(2)
game = Connect4::Game.new(board, player1, player2)
until game.game_over == true
  game.turn
end

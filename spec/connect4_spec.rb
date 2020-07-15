require "./lib/connect4"

describe "Move" do 
  describe "#move" do
    context "recieves valid move" do
      it "returns disk in column 1" do
        move_player = Connect4::Player.new(1)
        allow(move_player).to receive(:gets).and_return(1)
        move_player.get_move
        expect(move_player.move).to eql(1)        
      end
    end
  end
end

describe "Board" do
  describe "#add_chip" do
    add_chip_board = Connect4::Board.new
    add_chip_player = Connect4::Player.new(1)
    context "recieves valid move" do
      it "returns with chip value" do
        allow(add_chip_player).to receive(:gets).and_return(1)
        add_chip_player.get_move
        add_chip_board.add_chip(add_chip_player)
        expect(add_chip_board.cells[0][0].value).to eql("R")  
      end
    end
    context "column 1 is full" do
      it "returns which column is full" do
      allow(add_chip_player).to receive(:gets).and_return(1)
      6.times do
        add_chip_player.get_move
        add_chip_board.add_chip(add_chip_player)
      end
      expect(add_chip_board.full_column.include?(1)).to eql(true)  
      end
      it "returns message to player" do
        expect(add_chip_board.add_chip(add_chip_player)).to eql("Column full")
      end
    end
  end
end

describe "Game" do 
  describe "#win?" do 
    context "four vertical pieces for player 1 in col 1" do
      it "returns true" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        allow(player1).to receive(:gets).and_return(1)
        4.times do
          player1.get_move
          board.add_chip(player1)
        end
        expect(game.win?(player1)).to eql(true)
      end
    end
    context "mixed column with no winners" do
      it "returns false" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        allow(player1).to receive(:gets).and_return(1)
        allow(player2).to receive(:gets).and_return(1)
        2.times do
          player1.get_move
          board.add_chip(player1)
        end
        2.times do
          player2.get_move
          board.add_chip(player2)
        end
        player1.get_move
        board.add_chip(player1)
        expect(game.win?(player1)).to eql(false)
      end
    end
    context "four horizontal pieces for player 1 in row 1" do
      it "returns true" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        i = 3
        allow(player1).to receive(:gets).and_return(i)
        4.times do
          player1.get_move
          board.add_chip(player1)
          i += 1
        end
        expect(game.win?(player1)).to eql(true)
      end
    end
    context "mixed row with no winners" do
      it "returns false" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        i = 1
        allow(player1).to receive(:gets).and_return(i)
        allow(player2).to receive(:gets).and_return(i)
        3.times do
          player1.get_move
          board.add_chip(player1)
          i += 1
        end
        3.times do
          player2.get_move
          board.add_chip(player2)
          i += 1
        end
        player1.get_move
        board.add_chip(player1)
        expect(game.win?(player1)).to eql(false)
      end
    end
    context "four diagonal pieces for player 1" do
      it "returns true" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        i = 0
        move_array = [1, 2, 2, 3, 3, 4, 3, 4, 4, 6, 4, 6]
        until i == move_array.length 
          allow(player1).to receive(:gets).and_return(move_array[i])
          player1.get_move
          board.add_chip(player1)
          i += 1
          allow(player2).to receive(:gets).and_return(move_array[i])
          player2.get_move
          board.add_chip(player2)
          i += 1
        end
        expect(game.win?(player1)).to eql(true)
      end
    end
    context "mixed diagonal" do
      it "returns true" do
        player1 = Connect4::Player.new(1)
        player2 = Connect4::Player.new(2)
        board = Connect4::Board.new
        game = Connect4::Game.new(board, player1, player2)
        i = 0
        move_array = [1, 2, 6, 3, 3, 4, 3, 4, 4, 6, 4, 6]
        until i == move_array.length 
          allow(player1).to receive(:gets).and_return(move_array[i])
          player1.get_move
          board.add_chip(player1)
          i += 1
          allow(player2).to receive(:gets).and_return(move_array[i])
          player2.get_move
          board.add_chip(player2)
          i += 1
        end
        expect(game.win?(player1)).to eql(false)
      end
    end
  end
end
    
=begin
0 | 1 | 2
----------
3 | 4 | 5
----------
6 | 7 | 8
=end

COMBOS = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6]
]

def parse(str)
  spaces = str.strip.split.map{|space| space.to_i}
  Array.new(9).map {|x| spaces.shift}
end

def get_moves(board)
  (0..8).select{|i| board[i] == 0}
end

def check(board, positions)
  same = true
  first = board[positions.first]
  for position in positions
    if board[position] != first
      same = false
      break
    end
  end
  same and first != 0 ? first : false
end

def winner(board)
  for combo in COMBOS
    checked = check board, combo
    return checked if checked
  end
  return 0 unless board.member? 0
  false
end

def do_move(board, move, player)
  new_board = board.clone
  new_board[move] = player
  new_board
end

def worst_move(board, player)
  win = winner board
  return {:score => win} if win
  moves = get_moves board
  moves.map! do |move|
    new_board = do_move board, move, player
    {:move => move, :score => worst_move(new_board, -player)[:score]}
  end
  moves.sort! {|x, y| player * (x[:score] <=> y[:score])}
  moves.first
end

n = gets.to_i
n.times do
  board = parse gets
  p worst_move(board, 1)[:move]
end

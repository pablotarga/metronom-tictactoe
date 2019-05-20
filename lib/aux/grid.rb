module Aux
  class Grid
    class InvalidMoveError < Exception
    end

    class InvalidCellError < Exception
      def initialize(*args)
        super('Invalid cell configuration: %s' % args.inspect)
      end
    end

    attr_reader :size, :cells

    def initialize(size_or_origin)
      return clone_from(size_or_origin) if size_or_origin.is_a?(Grid)
      raise ArgumentError.new('Size must be numeric') unless size_or_origin.is_a?(Numeric)
      raise ArgumentError.new('Size must be greater than 0') if size_or_origin < 1
      @size = size_or_origin
      @cells = Array.new(size_or_origin**2, nil)
    end

    def get(col, row)
      cells[pos2index(col, row)]
    end

    def set(col, row, value)
      idx = pos2index(col, row)
      raise InvalidMoveError unless cells[idx].nil?
      cells[idx] = value
    end

    # needs to be a number between 0 and size
    def valid?(col, row)
      [col, row].all?{ |e| e.is_a?(Numeric) && e.between?(0, size-1) }
    end

    def valid_and_available?(col, row)
      valid?(col, row) && get(col, row).nil?
    end

    # Transform nil cells indexes into valid positions of the grid
    def available_positions
      (0...cells.size).select{|i| cells[i].nil? }.map{|i| index2pos(i)}
    end

    # return true if position is located on main diagonal (Size 3 => [0x0, 1x1, 2x2])
    def is_diag1?(col,row)
      valid?(col, row) && col == row
    end

    # return true if position is located on secondary diagonal (Size 3 => [0x2, 1x1, 2x0])
    def is_diag2?(col,row)
      valid?(col, row) && row == (size - (col+1))
    end

    # return all possible ranges to win a game (every column, every row and both diagonals)
    def get_all_ranges(position:false)
      ranges = [get_diag1(position:position), get_diag2(position:position)]
      (0...size).each{|i| ranges += [get_column(i,position:position), get_row(i,position:position)]}

      ranges
    end

    # return all possible ranges to win a game that  informed   belongs
    def get_ranges_for(col, row)
      return [] unless valid?(col,row)
      ranges = [get_row(row), get_column(col)]
      ranges << get_diag1() if is_diag1?(col, row)
      ranges << get_diag2() if is_diag2?(col, row)
      ranges
    end

    # get values(range) of informed row
    def get_row(row, position:false)
      return [] unless row < size
      s = row*size
      idxs = (s...s+size).to_a
      get_cells_values(idxs, position:position)
    end

    # get values(range) of informed column
    def get_column(col, position:false)
      return [] unless col < size
      idxs = (0...size).map{|e| e*size + col}
      get_cells_values(idxs, position:position)
    end

    # get values(range) of main diagonal
    def get_diag1(position:false)
      idxs = (0...size).map{|e| pos2index(e,e)}
      get_cells_values(idxs, position:position)
    end

    # get values(range) of secondary diagonal
    def get_diag2(position:false)
      idxs = (0...size).map{|e| pos2index(e,size-(e+1))}
      get_cells_values(idxs, position:position)
    end

    private

    def get_cells_values(idxs, position:false)
      values = cells.values_at(*idxs)
      return values unless position

      pos = idxs.map{|i| index2pos(i)}
      [pos, values].transpose.to_h
    end

    def clone_from(origin)
      @size  = origin.size
      @cells = origin.cells.clone
    end

    # transforms position(col, row) into index
    def pos2index(col, row)
      raise InvalidCellError.new(col: col, row: row) unless valid?(col, row)
      (row * size + col)
    end

    # transforms index into position(col, row)
    def index2pos(idx)
      idx = idx.to_i
      raise InvalidCellError.new(idx: idx) unless idx.between?(0,cells.size-1)
      [(idx%size), (idx/size)]
    end
  end
end

# The base class of all pieces - contains behaviors common to all pieces
class Piece  

  attr_accessor :side 
  attr_accessor :function
  attr_accessor :discriminator # eg queens, kings, promoted, a, b (for pawns)

  class << self
    attr_accessor :move_vectors, :moves_unlimited
  end

  # Allows a subclass to declare its moves
  # These are stored in instance variables on the class invoking this
  # Example:  move_directions :straight, :limit => none
  # http://martinfowler.com/bliki/ClassInstanceVariable.html
  def self.move_directions(*args)
    @move_vectors = args.include?(:straight) ? [[1,0],[-1,0],[0,1],[0,-1]] : []
    @move_vectors.concat( [[1,1],[-1,1],[1,-1],[-1,-1]] ) if args.include?(:diagonal)
    @moves_unlimited = args.last[:limit]==:none
  end

  def initialize(side, function, discriminator=nil)
    @side, @function = side, function
  end

  # default implementation, has no knowledge of capturability
  def self.allowed_move?(vector, starting_rank = nil)
    return false if vector == [0,0] #cant move to self
    return move_vectors.include?(vector) unless moves_unlimited

    move_vectors.each do |dir|
      1.upto(8).each do |multiple|
        return true if vector == [ dir[0]*multiple, dir[1]*multiple ]
      end
    end

    return false
  end

  # gives instances access to the class method, but allow child classes to override
  def allowed_move?(vector)
    self.class.allowed_move?(vector)
  end

  # when rendered the client id uniquely specifies an individual piece within a board
  # example: white_f_pawn
  def board_id
  end

  # a combination of the side and function
  def img_name
  end
    

end


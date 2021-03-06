module ConsoleDslImpl
  def self.included(base)
    help_msg =<<"EOF"
    
To use this console, first select a match:
  >> set match 3

Then make moves
  >> a2  #or Nc3, etc...
    
And enjoy !! (If any problems, restart as script/console --nodsl [environment]

EOF
    puts help_msg
    
    # put handlers in place to allow arbitrary typing of moves at the prompt
    base.instance_eval do
      # TODO - allow const_missing moves agian- maybe with alias method chain ?
      # for initial capital letter notation moves Nc4
      #def const_missing(name)
      #  puts "Eventually we will handle this, and it'll be beautiful, but for now... "
      #  move name
      #end
      # see later in the module where the method_missing definition is more normally pulled in
    end

  end

  ######## user interaction methods #########
  def current_match
    $current_match
  end
  def current_match= m
    $current_match = m
  end
  def m
    match = current_match
    def match.inspect
      board.inspect
    end
    match
  end
  alias :board :m
  def last; :last ;end
  
  def set match
    self.current_match = match
    puts current_match.board.to_s
  end

  # returns the match object that the passed identifier argument represents
  # parameters: ident - if a Match, returns the match, if :new, saves and returns
  # a new Match, if a Fixnum or Symbol invokes Match.find, or if a string, invokes Match.find_by_name
  def match ident
    case ident
      when Match
        ident
      when Fixnum, Symbol
        if ident == :new
          Match.create!(:white => Player.find(:first), :black => Player.find(:first) )
        else
          Match.find(ident)
        end
      when String
        Match.find_by_name(ident)
    end
  end

  def show
    puts @current_match.board.to_s
  end

  ######## methods to allow notation typing #########
  # delegate things typed to the move method
  #def method_missing(name, *args)
    #super unless name.grep(/[1-8]/)
  #  move name
  #end

  # returns a lambda to be called in the scope of the caller ???
  def move name
    puts "So you want to move to #{name}, eh ? Sorry, this feature not programmed / in experimental mode.. Soon though.. "
    puts "There is no current match! Type set match 3 or similar to establish a current match" and return unless current_match
    puts "Moving to #{name}..."
    current_match.moves << Move.new(:notation => name)
    puts current_match.board.to_s
  end

end

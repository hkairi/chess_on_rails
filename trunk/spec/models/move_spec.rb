require File.dirname(__FILE__) + '/../spec_helper'

describe Move, 'A move' do

  it "should be invalid without a from and to coordinate" do
    m = Move.new( :from_coord => :d4 )
    m.valid?.should == false
  end
  
  it 'should be able to use symbols to refer to its coordinates' do
    m = Move.new(:from_coord => :a2, :to_coord => :a4)
    m.from_coord.should == :a2
    m.to_coord.should == :a4
    
    m.capture_coord = :a4
    m.capture_coord.should == :a4
  end
  
  it 'should have its coordinates returned from database as symbols' do
    matches(:dean_vs_maria).moves.first.to_coord.should == :d4
  end

  it 'should be invalid with any invalid coordinates' do 
    move = Move.new(:from_coord => :a2, :to_coord => 'broken')
    move.valid?.should == false
  end
  
  it 'should know which side is moving (during validation)' do
    match = matches(:unstarted_match)
    move = match.moves.build(:from_coord => :g1, :to_coord => :f3)
    match.moves << move
    move.side_moving.should == :white
  end
end
require File.dirname(__FILE__) + '/spec_helper.rb'

describe "DCGOV::GeoCoder" do

  it "should be able to look up an address that exists" do
    results = DCGOV::GeoCoder.get({:address=>"441 4th str, nw"})
    results.length.should == 1
  end

  it "should be able to look up an address that doesn't exist" do
    results = DCGOV::GeoCoder.get({:address=>"1dsggdsdgssdgdsgdsgdsgdgsW"})
    results.length.should == 0
  end

  it "should be able to look up an address that has multiple results" do
    results = DCGOV::GeoCoder.get({:address=>"441 4th str"})
    results.length.should == 2
  end

  it "should be able to look up a latitude and a longitude" do
    results = DCGOV::GeoCoder.get({:lat=>"38.89544591",:lon=>"-77.01565221"})
    results[0].aid.should=="285552"
    results.length.should > 0
  end

  it "should be able to look up via a mar ID" do
    aid = 285552
    result = DCGOV::GeoCoder.get({:mar_id=>aid})
    result.aid.to_i.should == aid
  end

  it "should return nil when a nonsensical mar is thrown" do
    results = DCGOV::GeoCoder.get({:mar_id=>'adslkfhjdgsalkjgdlksdgjlgkds'})
    results.should == nil
  end

  #stupid test. for fun.
  it "should work" do
    DCGOV::GeoCoder.foo.should == "bar"
  end
  
end
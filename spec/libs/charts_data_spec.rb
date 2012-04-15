require File.expand_path("../../../extras/charts/data", __FILE__)
require 'active_support/all'

describe Charts::Data do

  context "collect_data" do
    before(:each) do 
      MonthlySummary = stub(:where => 
        stub( :last => 
          stub(:prices => ['full_prices'], 
               :values => ['full_values'])))
    end
    
    
    it "should return prices and values for period within month" do
      share = stub(:get_prices_for_period => ['part_prices'], :get_values_for_period => ['part_values'])
      from = Date.parse('2012-01-01')
      to   = Date.parse('2012-01-20')
      data = Charts::Data.new(share, from, to)
      data.collect_data
      data.instance_variable_get(:@prices).should == ['part_prices']
      data.instance_variable_get(:@values).should == ['part_values']
    end
    
    it "should return prices and values for period within several month" do
      share = stub(:get_prices_for_period => ['part_prices'], :get_values_for_period => ['part_values'])
      from = Date.parse('2012-01-01')
      to   = Date.parse('2012-03-20')
      data = Charts::Data.new(share, from, to)
      data.collect_data
      data.instance_variable_get(:@prices).should == ['full_prices', 'full_prices', 'part_prices']
      data.instance_variable_get(:@values).should == ['full_values', 'full_values', 'part_values']
    end
    
    it "should return prices and values for period within several full month" do
      share = stub(:get_prices_for_period => ['part_prices'], :get_values_for_period => ['part_values'])
      from = Date.parse('2012-01-01')
      to   = Date.parse('2012-03-31')
      data = Charts::Data.new(share, from, to)
      data.collect_data
      data.instance_variable_get(:@prices).should == ['full_prices', 'full_prices', 'full_prices']
      data.instance_variable_get(:@values).should == ['full_values', 'full_values', 'full_values']
    end
  end
  
  
  context "#months_in_period" do
    let(:share) { stub }
      
    it "should parse months by one month period" do
      from = Date.parse('2012-01-01')
      to   = Date.parse('2012-01-31')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[1, 2012]]
    end
    
    it "should parse months by one month period" do
      from = Date.parse('2012-03-01')
      to   = Date.parse('2012-04-30')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[3, 2012], [4, 2012]]
    end
    
    it "should parse months by period within month" do
      from = Date.parse('2012-01-01')
      to   = Date.parse('2012-01-20')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == []
    end
  
    it "should parse months by period within several month" do
      from = Date.parse('2012-01-10')
      to   = Date.parse('2012-03-20')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[2, 2012]]
    end
  
    it "should parse months by period within several month and include first full month" do
      from = Date.parse('2012-01-1')
      to   = Date.parse('2012-03-20')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[1, 2012], [2, 2012]]
    end
  
    it "should parse months by period within several month and include last full month" do
      from = Date.parse('2012-01-1')
      to   = Date.parse('2012-04-30')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[1, 2012], [2, 2012], [3, 2012], [4, 2012], [4, 2012]]
    end
  
    it "should parse months by period within several years" do
      from = Date.parse('2011-11-24')
      to   = Date.parse('2012-04-24')
      data = Charts::Data.new(share, from, to)
      data.months_in_period.should == [[12, 2011], [1, 2012], [2, 2012], [3, 2012], [4, 2012]]
    end
  
  end
end
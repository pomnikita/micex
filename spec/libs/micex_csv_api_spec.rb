# require 'spec_helper'
require File.expand_path("../../../extras/micex_csv_api", __FILE__)
require 'time'

describe MicexCsvApi do
  let(:share) do
    stub.extend(MicexCsvApi)
  end
  
  it "should parse from csv" do
    Time.stub(:now).and_return("now")
    file_string = "1268198428;19.07.2011;10:29:59;AFLT;EQBR;68,7;300;20610;;B".split(';')
    item = share.columns_from_row(file_string)
    item.delete("tradetime")
    expected = {"tradeno"=>"1268198428", "created_at"=>"now", "share_id"=>"aflt", "secid"=>"AFLT", "boardid"=>"EQBR", "price"=>68.7, "quantity"=>300, "buysell"=>"B"}
    item.should == expected 
  end
end

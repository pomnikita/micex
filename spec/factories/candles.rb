# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :candle do
      date "2011-12-05"
      period "MyString"
      start_time "2011-12-05 21:39:27"
      end_time "2011-12-05 21:39:27"
      open 1.5
      high 1.5
      low 1.5
      close 1.5
      volume 1
      value 1
      share_id "MyString"
    end
end
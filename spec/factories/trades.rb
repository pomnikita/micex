# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trade do
      TRADENO 1
      TRADETIME "2011-11-23 22:17:50"
      BOARDID "MyString"
      SECID "MyString"
      PRICE 1.5
      QUANTITY 1
      VALUE 1.5
      PERIOD "MyString"
      TRADETIME_GRP 1
      SYSTIME "2011-11-23 22:17:50"
      BUYSELL "MyString"
      DECIMALS 1
    end
end
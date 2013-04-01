# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :balance do
    store_id 1
    user_id 1
    category "MyString"
    reference_id 1
    amount 1.5
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expense do
    store_id 1
    user_id 1
    category "MyString"
    amount 1.5
    remark "MyString"
  end
end

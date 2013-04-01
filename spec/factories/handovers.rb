# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :handover do
    store_id 1
    user_id 1
    category "MyString"
    store_amount 1.5
    remark "MyString"
  end
end

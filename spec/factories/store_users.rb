# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_user do
    store_id 1
    user_id 1
    role "MyString"
  end
end

task :update_member_start_date => :environment do
  puts " =========== Start to update member start date ..."

  ActiveRecord::Base.connection.execute(" update members set start_date = created_at::date where start_date is null ")
  
  puts " =========== Updated."
end
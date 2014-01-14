task :update_member_start_date => :environment do
  puts " =========== Start to update member start date ..."

  ActiveRecord::Base.connection.execute(" update members set start_date = created_at::date where start_date is null ")
  
  puts " =========== Updated."
end

task :rollback_inventory => :environment do
  StockHistory.where(:adjust_category => "IC", :reference_id => InventoryDetail.where(:inventory_id => 19).map(&:id)).each do |history|
    stock = Stock.find(history.stock_id)
    stock.quantity +=  history.adjusted_by * (-1)
    stock.adjust_category = 'ICE'
    stock.reference_id = history.reference_id
    stock.change_qty = history.adjusted_by * (-1)
    stock.save!
  end

  sale = Sale.where(:id => 880).first
  sale.destroy if sale
  inventory = Inventory.find(19)
  inventory.status = 0
  inventory.save
end

class Inventory < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :remark #, :sum_amount, :pay_amount, :status

  attr_accessor :check_message

  belongs_to :store
  belongs_to :user

  has_many :inventory_details

  validates_presence_of :store_id, :user_id

  def number
    I18n.t(:inventory) + '#'+ ("%05d" % self.id)
  end

  def last_inventory
    Inventory.where(:store_id => self.store_id, :status => 1).where(" created_at < ? ", self.created_at).order(" id desc ").first
  end

  def last_inventory_from
    self.last_inventory.nil? ? 1.years.ago : self.last_inventory.created_at
  end

  
  def sum_pay_amount_by_me
    sales = Sale.select(" sum(actual_amount) as actual_amount ").where(:store_id => self.store_id, :category => 'O', :status => 1)
    sales = sales.where(" created_at > ? ", self.last_inventory.created_at) if self.last_inventory
    sales = sales.where(" created_at < ? ", self.created_at)
    sales.first.actual_amount
  end
  def sum_amount_of_me
    InventoryDetail.select(" sum(amount) as sum_amount ").where(:inventory_id => self.id).first.sum_amount
  end

  def is_owned_by?(agent)
    self.user == agent
  end

  def is_ok_to_confirm?
    is_ok = true
    is_ok = false if self.status > 0 
    is_ok = false if self.inventory_details.count == 0
    #is_ok = false if InventoryDetail.where(:inventory_id => self.id).where(" change_quantity < 0 ").exists?

    is_ok
  end





  def inventory_confirm
    if self.status != 0
      return false
    end

    if inventory_details.count == 0 
      return false
    end
    
    ActiveRecord::Base.transaction do
      sale = Sale.new(:store_id => self.store_id, :remark => self.number, :category => 'I')
      sale.user_id = self.user_id
      sale.score = 0
      sale.used_score = 0
      sale.actual_amount = 0
      sale.amount = 0
      sale.status = 1
      sale.save!


      self.sum_amount = self.sum_amount_of_me
      self.pay_amount = self.sum_pay_amount_by_me
      self.sale_id = sale.id
      self.status = 1
      self.save!

      
      inventory_details = InventoryDetail.where(:inventory_id => self.id )
      inventory_details.each do |d|
        sale_detail = SaleDetail.new(:sale_id => sale.id)
        sale_detail.product_id = d.product_id
        sale_detail.quantity = d.change_quantity
        sale_detail.unit_price = d.unit_price
        sale_detail.save!

        d.sale_detail_id = sale_detail.id
        d.save!


        stock = Stock.fetch(self.store_id, d.product_id)
        stock.quantity =  d.check_quantity
        stock.adjust_category = 'IC'
        stock.reference_id = d.id
        stock.change_qty = d.change_quantity * (-1)
        stock.save!
      end
    end

    true
  end



  #*************************
  # for owner, could cancel order
  #*************************
  def cancel
    if self.status != 1
      return false
    end

    ActiveRecord::Base.transaction do
      self.status = 9
      self.save!

      sale = Sale.find(self.sale_id) 
      sale.status = 9
      sale.save!
      
      inventory_details = InventoryDetail.where(:inventory_id => self.id )
      inventory_details.each do |d|
        stock = Stock.fetch(self.store_id, d.product_id)
        stock.quantity = d.stock_quantity 
        stock.adjust_category = 'ICE'
        stock.reference_id = d.id
        stock.change_qty =  d.change_quantity
        stock.save!
      end
    end
    true
  end


end

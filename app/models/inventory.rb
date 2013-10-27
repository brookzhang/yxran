class Inventory < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :remark #, :sum_amount, :pay_amount, :status
  belongs_to :store
  belongs_to :user

  has_many :inventory_details

  validates_presence_of :store_id, :user_id

  def number
    I18n.t(:inventory) + '#'+ ("%05d" % self.id)
  end

  
  def sum_pay_amount_by_me
    last_inventory = Inventory.where(:store_id => self.store_id).where(" created_at < ? ", self.created_at).order(" id desc ").first
    sales = Sale.select(" sum(actual_amount) as actual_amount ").where(:store_id => self.store_id, :category => 'O', :status => 1)
    sales = sales.where(" created_at > ? ", last_inventory.created_at) if last_inventory
    sales = sales.where(" created_at < ? ", self.created_at)
    sales.first.actual_amount
  end

  def is_owned_by?(agent)
    self.user == agent
  end

end

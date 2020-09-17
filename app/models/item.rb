class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price
  validates_presence_of :image, allow_blank: true
  validates_numericality_of :inventory, presence: true, greater_than_or_equal_to: 0
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.top_5
    order(quantity_purchased: :desc).limit(5)
  end

  def self.bottom_5
    order(quantity_purchased: :asc).limit(5)
  end

  def self.active_items
    self.where(active?: true)
  end

  def update_quantity_purchased(quantity)
    self.quantity_purchased += quantity
    self.inventory -= quantity
    self.save
  end
end

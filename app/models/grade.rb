class Grade < ActiveRecord::Base
  validates :name, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0}
  validates :max, numericality: { greater_than_or_equal_to: 1}

  belongs_to :component
end

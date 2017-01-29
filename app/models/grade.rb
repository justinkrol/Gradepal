class Grade < ActiveRecord::Base
  validates :name, presence: true
  [:score, :max].each { |n| validates n, numericality: { greater_than_or_equal_to: 0 } }

  belongs_to :component
end

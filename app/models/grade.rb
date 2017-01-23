class Grade < ActiveRecord::Base
  validates :name, presence: true
  [:score, :max].each { |n| validates n, numericality: { greater_than_or_equal_to: 0 } }

  belongs_to :component

  # return the grade as 0 <= percentage <= 1
  def percentage
    score.to_f / max
  end
end

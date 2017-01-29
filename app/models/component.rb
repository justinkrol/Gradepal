# Model for a course component (e.g. Assignments, Labs)
class Component < ActiveRecord::Base
  validates :name, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :course
  has_many :grades, dependent: :destroy
end

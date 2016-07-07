# Model for a course component (e.g. Assignments, Labs)
class Component < ActiveRecord::Base
  validates :name, presence: true, length: { minimum: 1 }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :course
  has_many :grades, dependent: :destroy

  def average
    return nil if grades.empty?
    # need to get percentages first since all grades in a single component
    # are assumed to have the same weight, regardless of maximum score
    # e.g. Average of { assignment1: {score: 9, max: 10},
    #                   assignment2: {score: 49, max: 50} }
    # is (.90 + .98) / 2 = .940
    # NOT (9 + 49) / (10 + 50) = .967
    grades
      .select { |e| !e.nil? }
      .map { :percentage }
      .reduce(:+) /
      grades.size
  end

  def w_average
    average.to_f * weight
  end
end

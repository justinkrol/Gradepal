# Course
class Course < ActiveRecord::Base
  [:name, :code].each { |n| validates n, presence: true, length: { minimum: 1 } }

  
  # belongs_to :semester # if degree-year-semester are added to the model
  belongs_to :user 
  has_many :components, dependent: :destroy
end

def average
  return nil if components.empty?
  # return the sum of weighted averages over the total weight of all components
  components
    .select { |e| !e.nil? }
    .map { :w_average } # map weighted average of each component
    .reduce(:+) /
    components
    .map { |component| component[:weight] }
    .reduce(:+)
end

def fullname
  "#{code} - #{name}"
end

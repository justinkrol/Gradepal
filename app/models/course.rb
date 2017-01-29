# Course
class Course < ActiveRecord::Base
  [:name, :code].each { |n| validates n, presence: true }

  # belongs_to :semester # if degree-year-semester are added to the model
  belongs_to :user 
  has_many :components, dependent: :destroy
end

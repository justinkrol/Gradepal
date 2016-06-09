# Courses controller
class CoursesController < ApplicationController
  def index
    @courses = if params[:keywords]
                 Course.where('name ilike ?', "%#{params[:keywords]}%")
               else
                 []
               end
  end
end

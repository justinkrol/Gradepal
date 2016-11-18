# Courses controller
class CoursesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @courses = if params[:keywords]
                 Course.where("code ilike :search or name ilike :search", {search: "%#{params[:keywords]}%"})
               else
                 Course.all
               end
  end

  def show
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(params.require(:course).permit(:name, :code))
    @course.save
    render 'show', status: 201
  end

  def update
    course = Course.find(params[:id])
    course.update_attributes(params.require(:course).permit(:name, :code))
    head :no_content
  end

  def destroy
    course = Course.find(params[:id])
    course.destroy
    head :no_content
  end
end

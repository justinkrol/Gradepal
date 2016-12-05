# Courses controller
class CoursesController < AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @courses = current_user.courses
    # @courses = params[:keywords] ? current_user.courses.where("code ilike :search or name ilike :search", {search: "%#{params[:keywords]}%"}) : current_user.courses
  end

  def show
    @course = current_user.courses.find(params[:id])
  end

  def create
    @course = current_user.courses.new(course_params)
    @course.save
    render 'show', status: 201
  end

  def update
    course = current_user.courses.find(params[:id])
    course.update_attributes(course_params)
    head :no_content
  end

  def destroy
    course = current_user.courses.find(params[:id])
    course.destroy
    head :no_content
  end

  private
  def course_params
    params.require(:course).permit(:name, :code, :user_id)
  end
end

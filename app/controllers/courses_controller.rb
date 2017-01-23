# Courses controller
class CoursesController < AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @courses = current_user.courses
  end

  def show
    @course = current_user.courses.find(params[:id])
  end

  def create
    @course = current_user.courses.new(course_params)
    if @course.save
      render 'show', status: 201
    else
      render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    course = Course.find(params[:id])
    if course.update(course_params)
      head :no_content
    else
      render json: { errors: course.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.courses.find(params[:id]).destroy
    head :no_content
  end

  private
  def course_params
    params.require(:course).permit(:name, :code)
  end
end

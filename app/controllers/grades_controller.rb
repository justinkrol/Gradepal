# Grades controller
class GradesController < AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @component = Component.find(params[:component_id])
    @grades = @component.grades.all
  end

  def show
    @grade = Grade.find(params[:id])
  end

  def create
    @component = Component.find(params[:component_id])
    @grade = @component.grades.new(grade_params)
    if @grade.save
      render 'show', status: 201
    else
      render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    grade = Grade.find(params[:id])
		if grade.update(grade_params)
      head :no_content
    else
      render json: { errors: grade.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Grade.find(params[:id]).destroy
    head :no_content
  end

  private
	def grade_params
		params.require(:grade).permit(:name, :score, :max, :component_id)
	end
end

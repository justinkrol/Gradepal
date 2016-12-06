# Grades controller
class GradesController < AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @component = Component.find(params[:component_id])
    @grades = @component.grades.all
    # @grades = Grade.where(component_id: params[:component_id]).take
  end

  def show
    @grade = Grade.find(params[:id])
  end

  def create
    @component = Component.find(params[:component_id])
    @grade = @component.grades.create(grade_params)
    render 'show', status: 201

    # @grade = Grade.new(params.require(:grade).permit(:name, :weight, :component_id)))
    # @grade.save
    # render 'show', status: 201
  end

  def update
    @grade = Grade.find(params[:id])
		@grade.update(grade_params)

    # grade = Grade.find(params[:id])
    # grade.update_attributes(params.require(:grade).permit(:name, :weight))
    head :no_content
  end

  def destroy
    grade = Grade.find(params[:id])
    grade.destroy
    head :no_content
  end

  private
		def grade_params
			params.require(:grade).permit(:name, :score, :max, :component_id)
		end

end

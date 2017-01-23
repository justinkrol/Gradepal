# Components controller
class ComponentsController < AuthenticatedController
  skip_before_filter :verify_authenticity_token

  def index
    @course = current_user.courses.find(params[:course_id])
    @components = @course.components
  end

  def show
    @component = Component.find(params[:id])
  end

  def create
    @course = current_user.courses.find(params[:course_id])
    @component = @course.components.new(component_params)
    if @component.save
      render 'show', status: 201
    else
      render json: { errors: @component.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    component = Component.find(params[:id])
		if component.update(component_params)
      head :no_content
    else
      render json: { errors: component.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Component.find(params[:id]).destroy
    head :no_content
  end

  private
	def component_params
		params.require(:component).permit(:name, :weight, :course_id)
	end
end

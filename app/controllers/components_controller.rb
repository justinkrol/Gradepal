# Components controller
class ComponentsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @course = Course.find(params[:course_id])
    @components = @course.components.all
    # @components = Component.where(course_id: params[:course_id]).take
  end

  def show
    @component = Component.find(params[:id])
  end

  def create
    @course = Course.find(params[:course_id])
    # debugger
    @component = @course.components.create(component_params)
    render 'show', status: 201

    # @component = Component.new(params.require(:component).permit(:name, :weight, :course_id)))
    # @component.save
    # render 'show', status: 201
  end

  def update
    @component = Component.find(params[:id])
		@component.update(component_params)

    # component = Component.find(params[:id])
    # component.update_attributes(params.require(:component).permit(:name, :weight))
    head :no_content
  end

  def destroy
    component = Component.find(params[:id])
    component.destroy
    head :no_content
  end

  private
		def component_params
			params.require(:component).permit(:name, :weight, :course_id)
		end

end

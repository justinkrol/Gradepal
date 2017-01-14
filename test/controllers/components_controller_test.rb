require 'test_helper'

class ComponentsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  def setup
    @user = users(:user1)
    sign_in @user
    @course = @user.courses.create!(code: 'SYSC 1005', name: 'Intro to Programming')
    @course.components.create!(name: 'Assignments', weight: 25)
    @course.components.create!(name: 'Tests', weight: 35)
    @course.components.create!(name: 'Final Exam', weight: 40)
  end

  # INDEX
  test "#index returns all components" do
    get :index,
      course_id: @course.id,
      format: :json

    # debugger
    assert_response 200
    assert components = JSON.parse(@response.body)
    assert_equal 3, components.size
  end

  test "#index returns child grades of a component" do
    @course.components.first.grades.create!(name: 'Assignment 1', score: 10, max: 10)
    get :index,
      course_id: @course.id,
      format: :json

    assert_response 200
    assert components = JSON.parse(@response.body)
    component = components.first
    assert_equal 1, component["grades"].count
  end

  # SHOW
  test "#show returns the correct component with the correct attributes when the component exists" do
    new_component = @course.components.create!(name: 'Assignments', weight: 30)
    get :show,
      id: new_component.id,
      format: :json

    assert_response 200
    assert component = JSON.parse(@response.body)
    assert_equal new_component.id, component["id"]
    assert_equal 'Assignments', component["name"]
    assert_equal 30, component["weight"]
  end

  test "#show returns 404 when the component does not exist" do
    get :show,
      id: -1,
      format: :json

    assert_response 404
  end

  # CREATE
  test "#create returns a component" do
    post :create,
      component: {
        name: 'Tests',
        weight: 22
      },
      course_id: @course.id,
      format: :json

    assert_response 201
    assert component = JSON.parse(@response.body)
    assert_equal 'Tests', component["name"]
    assert_equal 22, component["weight"]
  end

  # UPDATE
  test "#update successfully changes component attributes" do
    new_component = @course.components.create!(name: 'Final Exam', weight: 45)
    put :update,
      id: new_component.id,
      component: {
        name: 'Midterm Exam',
        weight: 30
      },
      format: :json
    new_component.reload

    assert_response 204
    assert_equal 'Midterm Exam', new_component.name
    assert_equal 30, new_component.weight
  end

  # DESTROY
  test "#destroy successfully deletes the component" do
    new_component = @course.components.create!(name: 'Assignments', weight: 25)
    delete :destroy,
      id: new_component.id,
      format: :json

    assert_response 204
    assert_nil Component.find_by_id(new_component.id)
  end
end

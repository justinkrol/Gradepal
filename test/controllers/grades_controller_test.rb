require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  def setup
    @user = users(:user1)
    sign_in @user
    course = @user.courses.create!(code: 'SYSC 1005', name: 'Intro to Programming')
    @component = course.components.create!(name: 'Assignments', weight: 25)
    @component.grades.create!(name: 'Assignment 1', score: 25, max: 30)
    @component.grades.create!(name: 'Assignment 2', score: 40, max: 43)
    @component.grades.create!(name: 'Assignment 3', score: 35, max: 35)
  end

  # INDEX
  test "#index returns all grades" do
    get :index,
      component_id: @component.id,
      format: :json

    # debugger
    assert_response 200
    assert grades = JSON.parse(@response.body)
    assert_equal 3, grades.size
  end

  # SHOW
  test "#show returns the correct grade with the correct attributes when the grade exists" do
    new_grade = @component.grades.create!(name: 'Test 1', score: 30, max: 40)
    get :show,
      id: new_grade.id,
      format: :json

    assert_response 200
    assert grade = JSON.parse(@response.body)
    assert_equal new_grade.id, grade["id"]
    assert_equal 'Test 1', grade["name"]
    assert_equal 30, grade["score"]
    assert_equal 40, grade["max"]
  end

  test "#show returns 404 when the grade does not exist" do
    get :show,
      id: -1,
      format: :json

    assert_response 404
  end

  # CREATE
  test "#create returns a grade" do
    post :create,
      grade: {
        name: 'Midterm 1',
        score: 75,
        max: 80
      },
      component_id: @component.id,
      format: :json

    assert_response 201
    assert grade = JSON.parse(@response.body)
    assert_equal 'Midterm 1', grade["name"]
    assert_equal 75, grade["score"]
    assert_equal 80, grade["max"]
  end

  # UPDATE
  test "#update successfully changes grade attributes" do
    new_grade = @component.grades.create!(name: 'Test 3', score: 45, max: 50)
    put :update,
      id: new_grade.id,
      grade: {
        name: 'Assignment 2',
        score: 40,
        max: 48
      },
      format: :json
    new_grade.reload

    assert_response 204
    assert_equal 'Assignment 2', new_grade.name
    assert_equal 40, new_grade.score
    assert_equal 48, new_grade.max
  end

  # DESTROY
  test "#destroy successfully deletes the grade" do
    new_grade = @component.grades.create!(name: 'Test 1', score: 25, max: 25)
    delete :destroy,
      id: new_grade.id,
      format: :json

    assert_response 204
    assert_nil Grade.find_by_id(new_grade.id)
  end
end

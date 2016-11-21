require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  def setup
    Course.create!(code: 'SYSC 1005', name: 'Intro to Programming')
    Course.create!(code: 'SYSC 3110', name: 'Software Project')
    Course.create!(code: 'COMP 3005', name: 'Databases')
    Course.create!(code: 'MATH 1005', name: 'Differential Equations')
  end

  # INDEX
  test "#index returns all courses if no keyword present" do
    get :index,
      format: :json

    assert_response 200
    assert courses = JSON.parse(@response.body)
    assert_equal 4, courses.size
  end

  test "#index returns two courses when keyword is 'SYSC'" do
    get :index,
      keywords: 'SYSC',
      format: :json

    assert_response 200
    assert courses = JSON.parse(@response.body)
    assert_equal 2, courses.size
    assert courses.map{|c| c["code"]}.include?('SYSC 1005')
    assert courses.map{|c| c["code"]}.include?('SYSC 3110')
  end

  test "#index returns no courses when keyword does not match" do
    get :index,
      keywords: 'zzz',
      format: :json

    assert_response 200
    assert courses = JSON.parse(@response.body)
    assert_equal 0, courses.size
  end

  # SHOW
  test "#show returns the correct course with the correct attributes when the course exists" do
    new_course = Course.create!(code: 'MATH 1004', name: 'Calculus 1')
    get :show,
      id: new_course.id,
      format: :json

    assert_response 200
    assert course = JSON.parse(@response.body)
    assert_equal new_course.id, course["id"]
    assert_equal 'MATH 1004', course["code"]
    assert_equal 'Calculus 1', course["name"]
  end

  test "#show returns 404 when the course does not exist" do
    get :show,
      id: -1,
      format: :json

    assert_response 404
  end

  # CREATE
  test "#create returns a course" do
    post :create,
      course: {
        code: 'MATH 1004',
        name: 'Calculus 1'
      },
      format: :json

    assert_response 201
    assert course = JSON.parse(@response.body)
    assert_equal 'MATH 1004', course["code"]
    assert_equal 'Calculus 1', course["name"]
  end

  # UPDATE
  test "#update successfully changes course attributes" do
    new_course = Course.create!(code: 'MATH 1004', name: 'Calculus 1')
    put :update,
      id: new_course.id,
      course: {
        code: 'COMP 1805',
        name: 'Discrete Structures'
      },
      format: :json
    new_course.reload

    assert_response 204
    assert_equal 'COMP 1805', new_course.code
    assert_equal 'Discrete Structures', new_course.name
  end

  # DESTROY
  test "#destroy successfully deletes the course" do
    new_course = Course.create!(code: 'MATH 1004', name: 'Calculus 1')
    delete :destroy,
      id: new_course.id,
      format: :json

    assert_response 204
    assert_nil Course.find_by_id(new_course.id)
  end
end

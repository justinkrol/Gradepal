require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def setup
    @course = courses(:comp_1805)
  end

  test "valid course" do
    assert @course.valid?
  end

  test "invalid course without code" do
    @course.code = nil
    refute @course.valid?
    assert_not_nil @course.errors[:code]
  end

  test "invalid course without name" do
    @course.name = nil
    refute @course.valid?
    assert_not_nil @course.errors[:name]
  end
end

require 'test_helper'

class GradeTest < ActiveSupport::TestCase
  def setup
    @grade = grades(:assignment_1)
  end

  test "valid grade" do
    assert @grade.valid?
  end

  test "invalid grade without name" do
    @grade.name = nil
    refute @grade.valid?
    assert_not_nil @grade.errors[:name]
  end

  test "invalid grade without score" do
    @grade.score = nil
    refute @grade.valid?
    assert_not_nil @grade.errors[:score]
  end

  test "invalid grade with negative score" do
    @grade.score = -1
    refute @grade.valid?
    assert_not_nil @grade.errors[:score]
  end

  test "invalid grade without max" do
    @grade.max = nil
    refute @grade.valid?
    assert_not_nil @grade.errors[:max]
  end

  test "invalid grade with negative max" do
    @grade.max = -1
    refute @grade.valid?
    assert_not_nil @grade.errors[:max]
  end
end

require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  def setup
    @component = components(:assignments)
  end

  test "valid component" do
    assert @component.valid?
  end

  test "invalid component without name" do
    @component.name = nil
    refute @component.valid?
    assert_not_nil @component.errors[:name]
  end

  test "invalid component without weight" do
    @component.weight = nil
    refute @component.valid?
    assert_not_nil @component.errors[:weight]
  end

  test "invalid component with negative weight" do
    @component.weight = -1
    refute @component.valid?
    assert_not_nil @component.errors[:weight]
  end
end

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should be valid" do
    users(:one).valid?
  end

  test "email not empty" do
    users(:one).email = "    "
    assert_not users(:one).valid?
  end

  test "invalid email" do
    users(:one).email = "kek"
    assert_not users(:one).valid?
  end

  test "duplicate email" do
    dup = users(:one).dup
    dup.save
    assert_not dup.valid?
  end

  test "authenticate" do
    assert !!users(:one).authenticate('testtest')
  end

  test "false authenticate" do
    assert_not !!users(:one).authenticate('test')
  end

end

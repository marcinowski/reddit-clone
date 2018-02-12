require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: 'test@test.com', password: 'testtest')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email not empty" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "invalid email" do
    @user.email = "kek"
    assert_not @user.valid?
  end

  test "duplicate email" do
    @dup = @user.dup
    @dup.save
    assert_not @dup.valid?
  end

  test "authenticate" do
    assert !!@user.authenticate('testtest')
  end

  test "false authenticate" do
    assert_not !!@user.authenticate('test')
  end

end

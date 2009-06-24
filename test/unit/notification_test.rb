require 'test_helper'

class NotificationTest < ActionMailer::TestCase
  test "welcome" do
    @expected.subject = 'Notification#welcome'
    @expected.body    = read_fixture('welcome')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_welcome(@expected.date).encoded
  end

  test "in_system" do
    @expected.subject = 'Notification#in_system'
    @expected.body    = read_fixture('in_system')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_in_system(@expected.date).encoded
  end

  test "update" do
    @expected.subject = 'Notification#update'
    @expected.body    = read_fixture('update')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_update(@expected.date).encoded
  end

end

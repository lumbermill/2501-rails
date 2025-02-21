require "test_helper"

class InquiriesMailerTest < ActionMailer::TestCase
  test "sent" do
    mail = InquiriesMailer.sent
    assert_equal "Sent", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "received" do
    mail = InquiriesMailer.received
    assert_equal "Received", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end

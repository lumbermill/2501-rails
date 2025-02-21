# Preview all emails at http://localhost:3000/rails/mailers/inquiries_mailer
class InquiriesMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/inquiries_mailer/sent
  def sent
    InquiriesMailer.sent
  end

  # Preview this email at http://localhost:3000/rails/mailers/inquiries_mailer/received
  def received
    InquiriesMailer.received
  end
end

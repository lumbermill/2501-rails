class InquiriesMailer < ApplicationMailer
  default from: "info@lmlab.net"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inquiries_mailer.sent.subject
  #
  def sent(to: "info@lmlab.net")
    @greeting = "Hi"
    mail to: to
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inquiries_mailer.received.subject
  #
  def received
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

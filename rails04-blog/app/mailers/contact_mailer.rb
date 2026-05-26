class ContactMailer < ApplicationMailer
  default to: (ENV['CONTACT_EMAIL'].presence || 'admin@example.com')

  def contact_email
    contact = params[:contact] || {}
    @name = contact['name'] || '未設定'
    @sender_email = contact['email'] || 'noreply@example.com'
    @message = contact['message'] || ''

    mail(from: @sender_email, subject: "お問い合わせ: #{@name}")
  end
end

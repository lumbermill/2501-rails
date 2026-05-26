require 'ostruct'

class ContactsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
    @contact = OpenStruct.new(name: nil, email: nil, message: nil)
  end

  def create
    contact_params = params.require(:contact).permit(:name, :email, :message)

    # Send email — uses CONTACT_EMAIL env or falls back to admin@example.com
    ContactMailer.with(contact: contact_params.to_h).contact_email.deliver_now

    redirect_to new_contact_path, notice: "お問い合わせを送信しました。返信が必要な場合はメールでご連絡します。"
  rescue => e
    logger.error "Contact form send failed: "+e.message
    flash.now[:alert] = "お問い合わせの送信中にエラーが発生しました。もう一度お試しください。"
    render :new, status: :internal_server_error
  end
end

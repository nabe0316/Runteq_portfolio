class PagesController < ApplicationController
  def terms
  end

  def privacy
  end

  def contact
  end

  def submit_contact
    name = params[:name]
    email = params[:email]
    message = params[:message]

    ContactMailer.contact_email(name, email, message).deliver_now

    flash[:notice] = 'お問い合わせを受け付けました。ありがとうございます。'
    redirect_to contact_path
  end
end

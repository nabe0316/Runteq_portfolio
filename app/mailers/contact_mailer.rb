class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: 'nabe0316rt@gmail.com', subject: '新しいお問い合わせ')
  end
end

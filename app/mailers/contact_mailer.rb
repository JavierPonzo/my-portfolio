class ContactMailer < ApplicationMailer
  def contact_email(name, email, message)
    @name = name
    @message = message

    mail(
      to: "ponzojavier@gmail.com",    
      from: email,
      subject: "New Contact Form Message from #{@name}"
    )
  end
end

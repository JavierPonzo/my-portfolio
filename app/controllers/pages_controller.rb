class PagesController < ApplicationController
  def index
  end

  def resume
  end

  def projects
  end

  def contact
  end

  def contact_submit
    ContactMailer.contact_email(
      params[:name],
      params[:email],
      params[:message]
    ).deliver_now
    redirect_to root_path, notice: "Message sent successfully!"
  end

end

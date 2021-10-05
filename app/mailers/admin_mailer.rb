class AdminMailer < ApplicationMailer

  default to: "hello@unirestaurantclub.com"

  def new_contact_form_submission_email
    @name = params[:name]
    @email = params[:email]
    @text = params[:text]
    @current_user_email = params[:current_user_email]

    mail subject: "New Contact Form Submission"
  end

  # a creator just confirmed that a review happened
  def just_reviewed_email_true
    @confirmation = params[:confirmation]
    @creators_html = TextContent.find_by(name: "creators just reviewed email")&.text
    @restaurant_html = TextContent.find_by(name: "restaurant just reviewed email")&.text
    @restaurant = @confirmation.restaurant
    @creator = @confirmation.content_creator

    mail subject: "A review just happened!"
  end

  # a creator just confirmed that a review DID NOThappen
  # we need to follow up to see what happened
  def just_reviewed_email_false
    @confirmation = params[:confirmation]
    @restaurant = @confirmation.restaurant
    @creator = @confirmation.content_creator


    mail subject: "UH OH a review did NOT happen!"
  end

  def confirm_review_happened
    @confirmation = params[:confirmation]
    @restaurant = @confirmation.restaurant

    mail bcc: "creators@unirestaurantclub.com",
      subject: "Confirm review happened emails sent"
  end

end

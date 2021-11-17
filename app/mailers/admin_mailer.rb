class AdminMailer < ApplicationMailer

  default to: "hello@unirestaurantclub.com"

  def sent_offers_to_all_creators_email
    @offer = params[:offer]
    @creator = @offer.content_creator
    @reason = params[:reason]
    @restaurant = @offer.restaurant
    @initial_creator_offers = @restaurant.creator_review_offers.first(2)
    @no_response_creators = []
    @initial_creator_offers.each do |offer|
      creator = offer.content_creator
      @no_response_creators << creator if offer.responded_at == nil
    end

    mail subject: "Offer emails sent out to all creators for #{@restaurant.name}"
  end

  def send_daily_summary_email
    @emails = params[:emails]
    @data = params[:data]
    time = Time.now
    date = "#{time.day}/#{time.month}/#{time.year}"

    mail to: @emails, subject: "URC Daily Summary #{date}"
  end

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

  # a creator just confirmed that a review DID NOT happen
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

  def send_review_time_scheduled_email
    @info = params[:info]
    @writer_offer = @info[:writer_offer]
    @writer = @writer_offer.content_creator
    @photographer_offer = @info[:photographer_offer]
    @photographer = @photographer_offer.content_creator
    @restaurant = @writer_offer.restaurant
    @option = @info[:option]
    @restaurant_html = TextContent.find_by(name: "notify restaurant that a review has been scheduled")&.text
    @no_charge_html = TextContent.find_by(name: "No Charge Confirmation email")&.text
    @creators_html = TextContent.find_by(name: "notify creators that a review has been scheduled")&.text
    mail subject: "A new review for #{@restaurant.name} has been scheduled!"
  end

end

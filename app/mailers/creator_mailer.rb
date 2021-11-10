class CreatorMailer < ApplicationMailer
  def confirm_review_happened
    @confirmation = params[:confirmation]
    @creator = @confirmation.content_creator
    @restaurant = @confirmation.restaurant
    @confirm_true_url = respond_api_v1_review_happened_confirmation_url(
      @confirmation.token, response: true)
    @confirm_false_url = respond_api_v1_review_happened_confirmation_url(
      @confirmation.token, response: false)
    @email = @creator.email
    @name = @creator.name

    mail to: @email, bcc: "monty@unirestaurantclub.com",
      subject: "Confirm review happened: #{@restaurant.name}"
  end

  def just_reviewed_email
    @restaurant = params[:restaurant]
    @creator = params[:creator]
    @name = @creator.name
    @html = TextContent.find_by(name: "creators just reviewed email")&.text

    mail to: @creator.email, bcc: "monty@unirestaurantclub.com",
      subject: "Review Follow Up Email for Uni Restaurant Club"
  end

  def review_offer_email
    @offer = params[:offer]
    @restaurant = @offer.restaurant
    @creator = @offer.content_creator

    mail to: @creator.email,
      subject: "We have a new restaurant offer for you! #{@restaurant.name}"
  end

  def send_review_time_scheduled_email
    @info = params[:info]
    @writer_offer = @info[:writer_offer]
    @writer = @writer_offer.content_creator
    @photographer_offer = @info[:photographer_offer]
    @photographer = @photographer_offer.content_creator
    @restaurant = @writer_offer.restaurant
    @option = @info[:option]
    @html = TextContent.find_by(name: "notify creators that a review has been scheduled")&.text
    mail to: [@writer.email, @photographer.email], bcc: "monty@unirestaurantclub.com",
      subject: "You have a new confirmed review time for #{@restaurant.name}!"
  end

end

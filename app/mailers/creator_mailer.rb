class CreatorMailer < ApplicationMailer
  def confirm_review_happened
    @confirmation = params[:confirmation]
    @creator = @confirmation.content_creator
    @restaurant = @confirmation.restaurant
    @confirm_url = edit_review_happened_confirmation_url(@confirmation.token)
    @email = @creator.email
    @name = @creator.name

    mail to: @email, bcc: "monty@unirestaurantclub.com",
      subject: "Confirm review happened: #{@restaurant.name}"
  end

  # if they responded to an offer but they were not selected
  # this is to notify them that they could not be selected
  def non_selected_email

    @offer = params[:offer]
    @restaurant = @offer.restaurant
    @creator = @offer.content_creator
    @name = @creator.name

    mail to: @creator.email, bcc: "monty@unirestaurantclub.com",
      subject: "You could not be matched for #{@restaurant.name}"
  end

  def just_reviewed_email
    @restaurant = params[:restaurant]
    @creator = params[:creator]
    @name = @creator.name
    @html = TextContent.find_by(name: "creators just reviewed email")&.text

    mail to: @creator.email, bcc: "monty@unirestaurantclub.com",
      subject: "URC Review Follow Up Email for #{@restaurant.name}"
  end

  def review_offer_email
    @offer = params[:offer]
    @everyone = params[:everyone]
    @restaurant = @offer.restaurant
    @creator = @offer.content_creator

    if @everyone
      subject = "SCRAMBLE! There is a review offer up for grabs! #{@restaurant.name}"
    else
      subject = "We have a new restaurant offer for you! #{@restaurant.name}"
    end
    mail to: @creator.email, bcc: "monty@unirestaurantclub.com",
      subject: subject
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

class RestaurantMailer < ApplicationMailer

  def restaurant_submitted_scheduling_info
    @restaurant = params[:restaurant]
    date = TimeHelpers.now_to_human
    mail to: @restaurant.primary_email,
      subject: "Scheduling info received! Thank you #{@restaurant.name}"
  end

  def send_outreach_email
    @restaurant = params[:restaurant]
    @first_text = TextContent.find_by(name: "restaurant outreach email first text")&.text
    @second_text = TextContent.find_by(name: "restaurant outreach email second text")&.text
    mail to: @restaurant&.primary_email, bcc: "monty@unirestaurantclub.com",
      subject: "Local restaurant club wants to do a feature on #{@restaurant.name}!"
  end

  def just_reviewed_email
    @restaurant = params[:restaurant]
    @name = @restaurant.name
    @html = TextContent.find_by(name: "restaurant just reviewed email")&.text

    mail to: @restaurant&.primary_email, bcc: "monty@unirestaurantclub.com",
      subject: "Thank you for letting us review you!"
  end

  def no_charge_confirmation_email
    @info = params[:info]
    @writer_offer = @info[:writer_offer]
    @writer = @writer_offer.content_creator
    @photographer_offer = @info[:photographer_offer]
    @photographer = @photographer_offer.content_creator
    @restaurant = @writer_offer.restaurant
    @option = @info[:option]
    @html = TextContent.find_by(name: "No Charge Confirmation email")&.text
    mail to: @restaurant.primary_email, bcc: "monty@unirestaurantclub.com",
         subject: "No Charge Confirmation"
  end

  def send_review_time_scheduled_email
    @info = params[:info]
    @writer_offer = @info[:writer_offer]
    @writer = @writer_offer.content_creator
    @photographer_offer = @info[:photographer_offer]
    @photographer = @photographer_offer.content_creator
    @restaurant = @writer_offer.restaurant
    @option = @info[:option]
    @html = TextContent.find_by(name: "notify restaurant that a review has been scheduled")&.text
    mail to: @restaurant.primary_email, bcc: "monty@unirestaurantclub.com",
      subject: "Your review date and time has been confirmed!"
  end

end

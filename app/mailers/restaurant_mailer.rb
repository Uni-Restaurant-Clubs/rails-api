class RestaurantMailer < ApplicationMailer
  def just_reviewed_email
    @restaurant = params[:restaurant]
    @name = @restaurant.name
    @html = TextContent.find_by(name: "restaurant just reviewed email")&.text

    mail to: @restaurant&.primary_email, bcc: "monty@unirestaurantclub.com",
      subject: "Thank you for letting us review you!"
  end

end

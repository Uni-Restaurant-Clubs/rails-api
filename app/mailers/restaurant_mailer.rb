class RestaurantMailer < ApplicationMailer
  def just_reviewed_email
    @restaurant = params[:restaurant]

    mail to: @restaurant.email, bcc: "hello@unirestaurantclub.com",
      subject: "Thank you for letting us review you!"
  end

end

class CreatorMailer < ApplicationMailer
  def confirm_review_happened
    @confirmation = params[:confirmation]
    @creator = @confirmation.content_creator
    @restaurant = @confirmation.restaurant
    @confirm_true_url = confirm_url(@confirmation.token, response: true)
    @confirm_false_url = confirm_url(@confirmation.token, response: false)
    @email = @creator.email
    @name = @creator.name

    mail to: @user.email, subject: "Confirm review happened"
  end

end

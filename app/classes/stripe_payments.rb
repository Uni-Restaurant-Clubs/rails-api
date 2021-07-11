class StripePayments

  def create_session(price_id)
		# Set your secret key. Remember to switch to your live secret key in production.
		# See your keys here: https://dashboard.stripe.com/apikeys
		Stripe.api_key = ENV["STRIPE_API_KEY"]

		session = Stripe::Checkout::Session.create({
  		success_url: "#{ENV['FRONTEND_WEB_URL']}/payment_success?session_id={CHECKOUT_SESSION_ID}}",
  		cancel_url: "#{ENV['FRONTEND_WEB_URL']}/payment_cancelled",
  		payment_method_types: ['card'],
  		mode: 'subscription',
  		line_items: [{
    		quantity: 1,
    		price: price_id,
  		}],
		})

    return session
  end
end

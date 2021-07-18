require 'stripe'

class StripePayments

  def self.create_checkout_session(price_id)
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

  def self.handleEvent(event, data)

  	# Get the type of webhook event sent
  	event_type = event['type']
  	data = event['data']
  	data_object = data['object']

  	case event.type
  	when 'checkout.session.completed'
    	# Payment is successful and the subscription is created.
    	# TODO You should provision the subscription and save the customer ID to your database.
  	when 'invoice.paid'
    	# Continue to provision the subscription as payments continue to be made.
    	# Store the status in your database and check when a user accesses your service.
    	# This approach helps you avoid hitting rate limits.
  	when 'invoice.payment_failed'
    	# The payment failed or the customer does not have a valid payment method.
    	# The subscription becomes past_due. Notify your customer and send them to the
    	# customer portal to update their payment information.
  	else
    	puts "Unhandled event type: \#{event.type}"
  	end

  end

end

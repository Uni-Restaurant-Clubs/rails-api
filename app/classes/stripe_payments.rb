require 'stripe'

class StripePayments

  def self.retreive_customer(user)
    return false unless user.stripe_customer_id
		Stripe.api_key = ENV["STRIPE_API_KEY"]
    Stripe::Customer.retrieve(
      id: user.stripe_customer_id,
      expand: ["subscriptions"])
  end

  def self.user_has_active_subscription(user)
    customer = self.retreive_customer(user)
    active = false
    customer.subscriptions.data.each do |subscription|
      active = true if subscription.status = "active"
    end
    return active
  end

  def self.create_checkout_session(price_id, user)
    return nil unless price_id && user

		# Set your secret key. Remember to switch to your live secret key in production.
		# See your keys here: https://dashboard.stripe.com/apikeys
		Stripe.api_key = ENV["STRIPE_API_KEY"]

    if !user.stripe_customer_id
      customer = Stripe::Customer.create({ email: user.email })
      user.stripe_customer_id = customer.id
      user.save!
    end

		session = Stripe::Checkout::Session.create({
  		success_url: "#{ENV['FRONTEND_WEB_URL']}/payment_success?session_id={CHECKOUT_SESSION_ID}}",
  		cancel_url: "#{ENV['FRONTEND_WEB_URL']}/payment_cancelled",
  		payment_method_types: ['card'],
      customer: user.stripe_customer_id,
  		mode: 'subscription',
  		line_items: [{
    		quantity: 1,
    		price: price_id,
  		}],
		})

    # add for discounts
      #discounts: [{
      #  coupon: 'WsRHmlKa',
      #}],

    return session
  end

  def self.handleEvent(event, data)
    Airbrake.notify("Stripe event happened: #{event['type']}", {
      event: event,
      data: data,
      event_type: event['type']
    })

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

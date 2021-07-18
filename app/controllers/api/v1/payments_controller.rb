require 'stripe'

class Api::V1::PaymentsController < Api::V1::ApiApplicationController

  before_action :authenticate_api_user!

  def handle_webhook
  	Stripe.api_key = ENV["STRIPE_API_KEY"]
  	webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']

  	payload = request.body.read
  	if !webhook_secret.empty?
    	# Retrieve the event by verifying the signature using
      # the raw body and secret if webhook signing is configured.
    	sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    	event = nil

    	begin
      	event = Stripe::Webhook.construct_event(
        	payload, sig_header, webhook_secret
      	)
    	rescue JSON::ParserError => e
        json = { error: true, message: "Invalid Payload" }.to_json
        render json: json, status: 400

    	rescue Stripe::SignatureVerificationError => e
        json = { error: true,
                 message: "Webhook signature verification failed." }.to_json
        render json: json, status: 404
    	end
  	else
    	data = JSON.parse(payload, symbolize_names: true)
    	event = Stripe::Event.construct_from(data)
  	end

    StripePayments.handleEvent(event, data)
    render json: {}, status: 204
	end

  def create_checkout_url
    price_id = params[:price_id]
    session = StripePayments.create_checkout_session(price_id, @current_user)
    if session.try(:url)
      json = { checkout_url: session.url }.to_json
      render json: json, status: 303
    else
      json = { error: true,
               message: "session url not found" }.to_json
      render json: json, status: 404
    end
  end

  def create_portal_url
    Stripe.api_key = ENV["STRIPE_API_KEY"]

    # This is the URL to which users will be redirected after they are done
    # managing their billing.
    return_url = ENV['FRONTEND_WEB_URL']
    customer_id = @current_user.stripe_customer_id

    session = Stripe::BillingPortal::Session.create({
      customer: customer_id,
      return_url: return_url,
    })
    if session.try(:url)
      json = { checkout_url: session.url }.to_json
      render json: json, status: 303
    else
      json = { error: true,
               message: "session url not found" }.to_json
      render json: json, status: 404
    end

  end
end

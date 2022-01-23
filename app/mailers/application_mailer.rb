require 'digest/sha2'

class ApplicationMailer < ActionMailer::Base
  default from: 'Uni Restaurant Club <hello@unirestaurantclub.com>'
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@unirestaurantclub.com"
  layout 'mailer'
end

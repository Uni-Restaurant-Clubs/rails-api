class CreatorReviewOffersController < ApplicationController

  def edit
    @offer = CreatorReviewOffer.find_by(token: params[:id])
  end

  def update
    binding.pry
  end
end

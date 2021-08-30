class Api::V1::ContentCreatorsController < Api::V1::ApiApplicationController

  def show
    creator = ContentCreator.find_by(public_unique_username: params[:id])
    if !creator
      json = { error: true, message: "No review for restaurant" }.to_json
      render json: json, status: 404
    else
      render json: creator, status: 200, serializer: ContentCreatorSerializer
    end
  end

end

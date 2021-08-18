class Identity < ApplicationRecord
  belongs_to "identity"

  validates_presence_of :user_id, :external_user_id, :provider
  validates_uniqueness_of :provider, scope: :external_user_id

  enum provider: { google: 0, facebook: 1, apple: 2 }

end

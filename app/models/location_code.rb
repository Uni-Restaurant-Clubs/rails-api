class LocationCode < ApplicationRecord
  has_many :content_creators

  default_scope { order(code: :asc) }

  validates_presence_of [:code, :state, :description]
  validates_uniqueness_of :code

  enum state: { "TX" => 0, "NY" => 1}

  def name
    code
  end
end

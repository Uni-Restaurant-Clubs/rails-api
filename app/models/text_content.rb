class TextContent < ApplicationRecord

  validates_presence_of :text, :category, :name
  enum category: { "email" => 0 }
end

class AddQualityRankingToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :quality_ranking, :integer, default: 1
    add_index :reviews, :quality_ranking
  end
end

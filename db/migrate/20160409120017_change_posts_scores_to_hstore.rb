class ChangePostsScoresToHstore < ActiveRecord::Migration
  def change
    add_column :students, :posts_scores, :hstore
    remove_column :students, :posts_score
  end
end

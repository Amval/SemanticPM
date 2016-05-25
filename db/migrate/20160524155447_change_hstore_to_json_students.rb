class ChangeHstoreToJsonStudents < ActiveRecord::Migration
  def change
    remove_column :students, :posts_scores
    add_column :students, :posts_scores, :hstore
  end
end

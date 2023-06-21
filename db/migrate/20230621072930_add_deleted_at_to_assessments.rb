class AddDeletedAtToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :deleted_at, :datetime
  end
end

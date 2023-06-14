class AddDeletedAtToParanoiac < ActiveRecord::Migration
  def change
    add_column :jobs, :deleted_at, :datetime
    add_column :employees, :deleted_at, :datetime
  end
end

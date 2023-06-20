class AddAssignTypeToAssessments < ActiveRecord::Migration
  def change
    add_column :assessments, :manual, :boolean, default: false 
  end
end
  
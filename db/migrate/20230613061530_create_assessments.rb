class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :job_id
      t.integer :employee_id

      t.timestamps null: false
    end
  end
end

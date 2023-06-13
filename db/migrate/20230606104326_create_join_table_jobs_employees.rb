class CreateJoinTableJobsEmployees < ActiveRecord::Migration
  def change
    create_join_table :jobs, :employees do |t|
      t.index [:job_id, :employee_id]
      t.index [:employee_id, :job_id]
    end
  end
end

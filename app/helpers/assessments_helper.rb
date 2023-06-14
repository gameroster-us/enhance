module AssessmentsHelper

  def employee_name(id)
    Employee.with_deleted.find(id).name
  end

  def job_name(id)
    Job.with_deleted.find(id).name
  end

  def count_days(emp_id, job_id)
    Assessment.where(employee_id: emp_id, job_id: job_id).count
  end
end

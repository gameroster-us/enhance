class AssessmentsController < ApplicationController
  def index
    @jobs = Job.with_deleted.all
    if params[:created_at].present?
      @assessments = Assessment.where('DATE(created_at) = ?', params[:created_at])
    end
  end

  def new
    @assessment = Assessment.new
  end

  def create
    @employee = params[:options]
    Job.all.each do |job|
      @employees = Hash[job.employees.map {|e| [e.id, Assessment.where(job_id: job.id, employee_id: e.id).count]}]
      @employees = @employees.sort_by {|_key, value| value }
      @employees.select! { |emp| @employee.include?(emp[0].to_s) }

      job.number_of_capacity.times do
        if @employees[0].present?
          emp_id = @employees[0][0]
          @ass = Assessment.create(job_id: job.id, employee_id: emp_id)
          @employee = @employee.reject { |val| val == emp_id.to_s} if @ass.present?
        end
      end
    end
    redirect_to assessments_path
  end
end

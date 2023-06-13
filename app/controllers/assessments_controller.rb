class AssessmentsController < ApplicationController
  def index
    @jobs = Job.all
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
      @job = Hash[job.employees.map {|e| [e.id, Assessment.where(job_id: job.id, employee_id: e.id).count]}]
      @job = @job.sort_by {|_key, value| value }
      @job = @job.reject { |a| @employee.include?(a.to_s) }
      index = 0
      job.number_of_capacity.times do
        if @job[index].present?
          emp_id = @job[index][0]
          Assessment.create(job_id: job.id, employee_id: emp_id)
          index += 1
        end
      end
    end
    redirect_to assessments_path
  end
end

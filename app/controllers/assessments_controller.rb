class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    if params[:created_at].present?
      @assessments = Assessment.where('DATE(created_at) = ?', params[:created_at])
    else
      @assessments = Assessment.all
    end
  end

  def new
    @assessment = Assessment.new
  end

  def manually_assign_job
    Assessment.create(assessments_params)
    redirect_to assessments_path
  end

  def create
    @employee = params[:options]
    if @employee.present?
      @job = []

      Job.count.times do |j|
        loop do
          @find_job = find_job
          if !@job.include?(@find_job)
            @job << @find_job
            break
          end
        end

        @employees = Hash[@find_job.employees.map {|e| [e.id, Assessment.where(job_id: @find_job.id, employee_id: e.id).count]}]
        @employees = @employees.sort_by {|_key, value| value }

        @find_job.number_of_capacity.times do
          @employees.select! { |emp| @employee.include?(emp[0].to_s) }

          if @employees.first.present?
            emp_id = @employees.first[0]
            created_at = params[:created_at].present? ? params[:created_at] : Time.now
            @ass = Assessment.create(job_id: @find_job.id, employee_id: emp_id, created_at: created_at)
            @employee = @employee.reject { |val| val == emp_id.to_s} if @ass.present?
          end
        end
      end
      redirect_to assessments_path
    else
      redirect_to new_assessment_path
    end
  end

  private
  def find_job
    if Assessment.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day).blank?
      employee_with_minimum_jobs = Employee.all.min_by { |employee| employee.jobs.count }
      employee_with_minimum_jobs.jobs.last
    else
      Job.all.sample
    end
  end

  def assessments_params
    params.require(:assessment).permit(:employee_id, :job_id, :created_at)
  end
end

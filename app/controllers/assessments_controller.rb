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
          @ass = Assessment.create(job_id: @find_job.id, employee_id: emp_id)
          @employee = @employee.reject { |val| val == emp_id.to_s} if @ass.present?
        end
      end
    end
    redirect_to assessments_path
  end

  private
  def find_job
    if Assessment.where(created_at: Date.today.beginning_of_day..Date.today.end_of_day).blank?
      Job.second
    else
      Job.all.sample
    end
  end
end

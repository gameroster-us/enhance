require 'csv'

class AssessmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    get_data
    csv_data
    respond_to do |format|
      format.html
      format.csv { send_data csv_data.to_csv, filename: "Data-#{Date.today}.csv" }
    end
  end
  

  def new
    @assessment = Assessment.new
  end

  def manually_assign_job
    assessment = Assessment.new(assessments_params)
    assessment.manual = true
    assessment.save
    
    redirect_to assessments_path(assessments_params)
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
      redirect_to assessments_path(created_at: params[:created_at])
    else  
      redirect_to new_assessment_path
    end
  end

  private
  def find_job
    if Assessment.where(created_at: params[:created_at]).blank?
      employee_with_minimum_jobs = Employee.all.min_by { |employee| employee.jobs.count }
      employee_with_minimum_jobs.jobs.first
    else
      Job.all.sample
    end
  end

  def assessments_params
    params.require(:assessment).permit(:employee_id, :job_id, :created_at)
  end

  def csv_data
    if params[:created_at].present?
      date = Date.parse(params[:created_at])
      assessments = Assessment.where(created_at: params[:created_at])
    else  
      assessments = if params[:from_date].present? && params[:to_date].present?
                    from_date = Date.parse(params[:from_date])
                    to_date = Date.parse(params[:to_date])
                    Assessment.where(created_at: from_date.beginning_of_day..to_date.end_of_day)
                    else
                    date = Date.today
                    assessments = Assessment.where(created_at: date)
                    end
    end
  end
  
  def get_data
    @assessments = csv_data.group_by { |assessment| [assessment.job_id, assessment.created_at.to_date] }.transform_values do |values|
      job_name = Job.find(values.first.job_id).name
      employee_names = values.map { |assessment| Employee.find(assessment.employee_id).name }
      created_date = values.first.created_at.to_date
      { job_name: job_name, employee_names: employee_names, created_date: created_date }
    end
    
  end
end

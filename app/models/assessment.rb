class Assessment < ActiveRecord::Base
  validates :job_id, :employee_id, presence: true
  acts_as_paranoid
  belongs_to :job
  belongs_to :employee
  def assessment_type
    manual? ? 'Manual' : 'Automatic'
  end

  def self.to_csv
    attributes = %w{id assessment_type employee_name project_name created_at }

    CSV.generate(headers: true) do |csv|
      csv << attributes
   
      all.find_each do |user|
        employee_name = Employee.find_by(id: user.employee_id)
        employee_name = employee_name.name
        project_name = Job.find_by(id: user.job_id)
        project_name = project_name.name
        created_at = user.created_at.strftime("%d/%m/%Y")
        csv << attributes.map do |attr|
          case attr
          when 'employee_name'
            employee_name
          when 'project_name'
            project_name
          when 'created_at'
            created_at
          else
            user.send(attr)
          end
        end
      end
    end
  end
end

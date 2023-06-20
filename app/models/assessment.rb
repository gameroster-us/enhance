class Assessment < ActiveRecord::Base
  validates :job_id, :employee_id, presence: true

  def assessment_type
    manual? ? 'Manual' : 'Automatic'
  end
end

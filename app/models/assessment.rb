class Assessment < ActiveRecord::Base
  validates :job_id, :employee_id, presence: true
  acts_as_paranoid
  belongs_to :job
  belongs_to :employee
  def assessment_type
    manual? ? 'Manual' : 'Automatic'
  end
end

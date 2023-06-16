class Assessment < ActiveRecord::Base
  validates :job_id, :employee_id, presence: true
end

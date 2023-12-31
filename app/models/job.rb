class Job < ActiveRecord::Base
  acts_as_paranoid
  has_and_belongs_to_many :employees
  has_many :assessments, dependent: :destroy
end

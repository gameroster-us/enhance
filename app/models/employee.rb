class Employee < ActiveRecord::Base
  acts_as_paranoid
  has_and_belongs_to_many :jobs
  has_many :assessments, dependent: :destroy
end

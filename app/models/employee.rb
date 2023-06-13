class Employee < ActiveRecord::Base
  has_and_belongs_to_many :jobs

  def self.assign_job
  end
end

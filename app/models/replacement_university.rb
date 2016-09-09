class ReplacementUniversity < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :state
  has_many :colleges
  has_many :batch_applicants, through: :colleges
end

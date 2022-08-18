class Relationship < ApplicationRecord
  belongs_to :exam
  belongs_to :question
  validates :exam_id, presence: true
  validates :question_id, presence: true
end

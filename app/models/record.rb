class Record < ApplicationRecord
  belongs_to :exam
  belongs_to :answer
  validates :exam_id, presence: true
  validates :answer_id, presence: true
end

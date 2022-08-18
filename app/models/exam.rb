class Exam < ApplicationRecord
  enum status: {start: 0, completed: 1, failed: 2, passed: 3}

  belongs_to :user
  belongs_to :subject

  has_many :question_relationships, class_name: Relationship.name,
                                    dependent: :destroy
  has_many :questions, through: :question_relationships, source: :question

  validates :user_id, presence: true
  validates :subject_id, presence: true

  scope :newest, ->{order(created_at: :desc)}

  def add question
    questions << question
  end
end

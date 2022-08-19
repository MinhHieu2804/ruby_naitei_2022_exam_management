class Exam < ApplicationRecord
  ANSWER_ATTRS = %i(question_id answer_id).freeze
  EXAM_ATTRS = %i(question: ANSWER_ATTRS).freeze

  enum status: {start: 0, doing:1, completed: 2, failed: 3, passed: 4}

  belongs_to :user
  belongs_to :subject

  has_many :question_relationships, class_name: Relationship.name,
                                    dependent: :destroy
  has_many :questions, through: :question_relationships, source: :question
  has_many :answer_relationships, class_name: Record.name, dependent: :destroy
  has_many :answers, through: :answer_relationships, source: :answer

  validates :user_id, presence: true
  validates :subject_id, presence: true

  scope :newest, ->{order(created_at: :desc)}

  def add question
    questions << question
  end

  def add_record answer
    answers << answer
  end
end

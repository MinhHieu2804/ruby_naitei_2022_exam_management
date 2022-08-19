class ExamsController < ApplicationController
  def show
    @exam = Exam.find_by id: params[:id]
    @questions = @exam.questions
    return unless @exam.start?

    @exam.update status: 1
    @exam.update endtime: Time.zone.now + @exam.subject.duration.minutes
  end

  def create
    @exam = Exam.new exam_params
    @exam.user_id = current_user.id
    if @exam.save
      add_questions_to_exam
      flash[:success] = t ".success_create"
      redirect_to root_path
    else
      flash.now[:error] = t ".fail_create"
    end
  end

  def update
    @exam = Exam.find_by id: params[:id]
    params[:exam][:question].each_value do |value|
      @exam.add_record  Answer.find_by id: value["id"]
    end
    grade
    redirect_to root_path
  end

  private
  def exam_params
    params.require(:exam).permit :subject_id
  end

  def add_questions_to_exam
    questions = Question.where(subject_id: @exam.subject.id)
    @exam.add questions
  end

  def user_answer_params
    params.require(:exam).permit Exam::EXAM_ATTRS
  end

  def grade
    result = 0
    exam_question = @exam.questions
    correct_answers = []
    exam_question.each do |question|
      correct_answers.push question.answers.where(is_correct: true)
    end

    user_answers = @exam.answers

    user_answers.each do |answer|
      if answer in correct_answers
        result += 1
      end
    end
    @exam.update result: result
  end
end

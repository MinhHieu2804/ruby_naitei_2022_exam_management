class ExamsController < ApplicationController
  def create
    @exam = Exam.new exam_params
    @exam.user_id = current_user.id
    if @exam.save
      flash[:success] = t ".success_create"
      redirect_to root_path
    else
      flash.now[:error] = t ".fail_create"
    end
  end

  private
  def exam_params
    params.require(:exam).permit :subject_id
  end

  def add_question; end
end

class Admin::QuestionsController < Admin::BaseController
  before_action :find_question, except: %i(index new create)

  def index
    store_location
    questions = Question.by_subject(params[:subject_id])
    @search = questions.ransack question_content_cont:
                                params[:q] ? params[:q][:question_content] : ""
    @search.sorts = params.dig(:q, :s) || "id asc"
    handle_param
  end

  def new
    @question_index = 1
    @question = Question.new
    @subject = Subject.pluck :name, :id
    @question.answers.build
    @question.answers.build
  end

  def create
    @question = Question.new question_params
    @subject = Subject.pluck :name, :id
    if @question.save
      flash[:success] = t ".created"
      redirect_back_or admin_questions_path
    else
      flash[:error] = t ".create_failed"
      render :new
    end
  end

  def edit
    @subject = Subject.pluck :name, :id
    @type = Question.types
  end

  def update
    @answer_item = Question.find_by id: params[:id]
    @subject_id = @question.subject_id
    if @question.update question_params
      flash[:success] = "update_success"
      redirect_back_or admin_questions_path
    else
      flash[:danger] = "update_false"
      render :edit
    end
  end

  def destroy
    if @question.includes([:answers]).destroy
      flash[:success] = "Question deleted"
    else
      flash[:danger] =  "Questiom delete failed"
    end
    redirect_back_or admin_questions_path
  end

  private
  def question_params
    params.require(:question).permit Question::QUESTION_ATTRS
  end

  def find_question
    @question = Question.find_by id: params[:id]
    return if @question.present?

    flash[:danger] = t "not_found"
    redirect_to admin_questions_path
  end

  def handle_param
    if params[:subject_id]
      sub_path = new_admin_subject_question_path(params[:subject_id])
      search_path = admin_subject_questions_path(params[:subject_id])
    end
    @pagy, @question_item = pagy @search.result, items: Settings.pagy
    @search_path = params[:subject_id] ? search_path : admin_questions_path
    @path = params[:subject_id] ? sub_path : new_admin_question_path
  end
end

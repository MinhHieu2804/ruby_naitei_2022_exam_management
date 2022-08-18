class StaticPagesController < ApplicationController
  def home
    @subject = Subject.pluck :name, :id
    @exam = Exam.new

    @pagy, @exam_item = pagy Exam.newest, items: Settings.pagy
  end
end

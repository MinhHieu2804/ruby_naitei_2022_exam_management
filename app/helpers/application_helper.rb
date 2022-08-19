module ApplicationHelper
  include Pagy::Frontend
  # rubocop:disable Rails/OutputSafety
  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      type = "success" if type == "notice"
      type = "error" if type == "alert"
      type = "warning" if type == "danger"
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end.join("\n").html_safe
  end

  # rubocop:enable Rails/OutputSafety
  def full_title page_title = ""
    base_title = t "base_title"
    page_title.blank? ? base_title : [page_title, base_title].join(" | ")
  end

  def error_message object, field
    message = object.errors[field].first if object.errors[field].present?
    content_tag(:div, message, class: "text-danger")
  end

  def icon_active_or_inactive user
    if user.activated
      "fa-lock fa icon inactive-icon"
    else
      "fa fa-unlock icon active-icon"
    end
  end

  def status_exam exam
    if exam.start?
      return content_tag(:span, exam.status,
                         class: "status start-status")
    end
    if exam.completed?
      return content_tag(:span, exam.status,
                         class: "status completed-status")
    end
    if exam.failed?
      return content_tag(:span, exam.status,
                         class: "status failed-status")
    end

    return unless exam.passed?

    content_tag(:span, exam.status,
                class: "status passed-status")
  end

  def button_exam exam
    button_text = exam.status == "start" ? "Start" : "View"
    if button_text == "Start"
      link_to "Start", exam_path(exam.id), class: "btn btn-primary"
    else
      link_to "View", "#", class: "btn btn-success"
    end
  end

  def status_account user
    user.activated ? "active" : "inactive"
  end
end

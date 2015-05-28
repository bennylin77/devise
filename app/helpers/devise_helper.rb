module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?
=begin
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
=end
    html=''
    resource.errors.full_messages.each do |message|
      html = html + "<script> toastr['error']('#{message}') </script>"
    end
    html.html_safe
  end

end
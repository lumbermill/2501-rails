module ApplicationHelper
  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?

      t = "light"
      t = "info" if type == "notice"
      t = "danger" if type == "alert"

      flash_messages << content_tag(:div, message.html_safe, class: "alert alert-#{t}")
    end
    flash_messages.join("\n").html_safe
  end
end

module ApplicationHelper
  # Root-level manifest URL so Forward Auth does not redirect (avoids CORS).
  # Override via PWA_MANIFEST_BASE_URL when the public origin differs (e.g. behind proxy).
  def pwa_manifest_root_url
    base = ENV["PWA_MANIFEST_BASE_URL"].presence || request.base_url
    base.to_s.sub(/\/*\z/, "") + "/manifest.json"
  end

  def available_locales_for_select
    Rails.application.config.i18n.available_locales.map { |locale| [ t("locales.name.#{locale}", default: locale.to_s), locale.to_s ] }
  end

  def page_title_tag
    account_name = if Current.account && Current.session&.identity&.users&.many?
      Current.account&.name
    end
    tag.title [ @page_title, account_name, "Fizzy" ].compact.join(" | ")
  end

  def icon_tag(name, **options)
    tag.span class: class_names("icon icon--#{name}", options.delete(:class)), "aria-hidden": true, **options
  end

  def back_link_to(label, url, action, **options)
    link_to url, class: "btn btn--back btn--circle-mobile", data: { controller: "hotkey", action: action }, **options do
      icon_tag("arrow-left") + tag.strong(t("shared.back_to_label", label: label), class: "overflow-ellipsis") + tag.kbd("ESC", class: "txt-x-small hide-on-touch").html_safe
    end
  end

  # When true, Forward Auth is enabled and logout should be hidden/disabled.
  def forward_auth_enabled?
    cfg = Rails.application.config.forward_auth
    cfg.is_a?(ForwardAuth::Config) && cfg.enabled?
  end

  # When false, do not render any email display in the UI (hide email elements).
  def show_email_in_ui?
    !Fizzy.hide_emails?
  end

  # Returns the email to display in the UI. When Fizzy.hide_emails? is true, returns blank so elements can be hidden.
  def display_email(email)
    return "" if email.blank?
    return "" if Fizzy.hide_emails?
    email.to_s
  end

  # For use in sentences like "Sent to …". When hiding, returns a generic "your email" so the sentence still reads well.
  def display_email_in_sentence(email)
    return "" if email.blank?
    return t("shared.your_email") if Fizzy.hide_emails?
    email.to_s
  end
end

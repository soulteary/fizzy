module Fizzy
  class << self
    def saas?
      return @saas if defined?(@saas)
      @saas = !!(((ENV["SAAS"] || File.exist?(File.expand_path("../tmp/saas.txt", __dir__))) && ENV["SAAS"] != "false"))
    end

    # When true, account export and user data export are available in the UI and via API.
    # Set DISABLE_EXPORT_DATA=true to turn off and hide all export data functionality.
    def export_data_enabled?
      return @export_data_enabled if defined?(@export_data_enabled)
      @export_data_enabled = ENV["DISABLE_EXPORT_DATA"] != "true"
    end

    # When true, user email addresses are hidden across the UI (replaced with a placeholder).
    # Set HIDE_EMAILS=true to enable. Does not affect mail delivery or form inputs.
    def hide_emails?
      return @hide_emails if defined?(@hide_emails)
      @hide_emails = ENV["HIDE_EMAILS"] == "true"
    end

    def db_adapter
      @db_adapter ||= DbAdapter.new ENV.fetch("DATABASE_ADAPTER", saas? ? "mysql" : "sqlite")
    end

    def configure_bundle
      if saas?
        ENV["BUNDLE_GEMFILE"] = "Gemfile.saas"
      end
    end
  end

  class DbAdapter
    def initialize(name)
      @name = name.to_s
    end

    def to_s
      @name
    end

    # Not using inquiry so that it works before Rails env loads.
    def sqlite?
      @name == "sqlite"
    end
  end
end

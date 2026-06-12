# frozen_string_literal: true

module VaultTemplates
  TEMPLATES = {
    "preferences" => [
      {name: :time_zone, type: :string, default: '"UTC"'},
      {name: :locale, type: :string, default: '"en"'},
      {name: :date_format, type: :string, default: '"dd-mm-yyyy"'},
      {name: :time_format, type: :string, default: '"24h"'},
      {name: :density, type: :string, default: '"default"'},
      {name: :hotkeys_disabled, type: :boolean, default: "false"}
    ],

    "notification_settings" => [
      {name: :email_enabled, type: :boolean, default: "true"},
      {name: :push_enabled, type: :boolean, default: "true"},
      {name: :sms_enabled, type: :boolean, default: "false"},
      {name: :email_frequency, type: :string, default: '"daily"'},
      {name: :quiet_hours_start, type: :string, default: '"22:00"'},
      {name: :quiet_hours_end, type: :string, default: '"08:00"'}
    ],

    "feature_flags" => [
      {name: :new_dashboard_enabled, type: :boolean, default: "false"},
      {name: :beta_features_enabled, type: :boolean, default: "false"},
      {name: :experimental_ai_assistant, type: :boolean, default: "false"},
      {name: :dark_mode_beta, type: :boolean, default: "false"}
    ],

    "email_sequence" => [
      {name: :sequence_name, type: :string, default: '"welcome"'},
      {name: :current_step, type: :integer, default: "0"},
      {name: :total_steps, type: :integer, default: "5"},
      {name: :started_at, type: :datetime},
      {name: :completed_at, type: :datetime},
      {name: :skipped, type: :boolean, default: "false"}
    ]
  }
end

# frozen_string_literal: true

require "bundler/setup"
require "rails"
require "minitest/autorun"
require "active_record"
require "action_dispatch"
require "action_controller"

require "store_attribute"
require "rails_vault"

ActiveRecord::Base.include(RailsVault::Vaults)

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = nil

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name

    t.timestamps
  end

  create_table :accounts, force: true do |t|
    t.string :name

    t.timestamps
  end

  create_table :rails_vaults, force: true do |t|
    t.references :resource, polymorphic: true, null: false
    t.string :scope, null: false
    t.json :payload, null: false, default: {}

    t.timestamps
  end
end

module RailsVault
  class UserPreferences < Base
    vault_attribute :time_zone, :string, default: "UTC"
    vault_attribute :email_frequency, :string, default: "daily"
    vault_attribute :notifications_enabled, :boolean, default: true
    vault_attribute :max_items, :integer, default: 100
  end

  class AccountSettings < Base
    vault_attribute :theme, :string, default: "light"
    vault_attribute :notifications, :boolean, default: true
  end

  class AccountBilling < Base
    vault_attribute :plan, :string, default: "free"
    vault_attribute :monthly_limit, :integer, default: 1000
  end
end

class User < ActiveRecord::Base
  vault :user_preferences, class_name: "RailsVault::UserPreferences"
end

class Account < ActiveRecord::Base
  vault :account_settings, class_name: "RailsVault::AccountSettings"
  vault :account_billing, class_name: "RailsVault::AccountBilling"
end

class ActiveSupport::TestCase
  def teardown
    RailsVault::Base.delete_all
    User.delete_all
    Account.delete_all

    super
  end
end

# frozen_string_literal: true

require "test_helper"

module RailsVault
  class BaseTest < ActiveSupport::TestCase
    test "stores data in payload column" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user, time_zone: "Amsterdam")

      vault.reload
      assert_equal "Amsterdam", vault.payload["time_zone"]
    end

    test "vault_attribute creates accessor with default value" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user)

      assert_equal "UTC", vault.time_zone
    end

    test "vault_attribute allows writing value" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user)

      vault.time_zone = "Berlin"
      vault.save!
      vault.reload

      assert_equal "Berlin", vault.time_zone
    end

    test "vault_attribute string type" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user, email_frequency: "weekly")

      assert_equal "weekly", vault.email_frequency
    end

    test "vault_attribute boolean type" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user, notifications_enabled: false)

      assert_equal false, vault.notifications_enabled
    end

    test "vault_attribute boolean predicate method" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user, notifications_enabled: true)

      assert vault.notifications_enabled?
    end

    test "vault_attribute integer type" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user, max_items: 50)

      assert_equal 50, vault.max_items
    end

    test "vault_attributes returns array of attribute names" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user)

      attributes = vault.vault_attributes

      assert_includes attributes, "time_zone"
      assert_includes attributes, "email_frequency"
      assert_includes attributes, "notifications_enabled"
      assert_includes attributes, "max_items"
    end

    test "vault_scope scopes by class name" do
      user = User.create!(name: "Test User")

      UserPreferences.create!(resource: user)
      UserPreferences.create!(resource: user, time_zone: "London")

      results = UserPreferences.all
      assert_equal 2, results.length
    end

    test "belongs_to polymorphic resource" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user)

      assert_instance_of User, vault.resource
      assert_equal user.id, vault.resource_id
      assert_equal "User", vault.resource_type
    end

    test "dependent destroy removes vault when resource destroyed" do
      user = User.create!(name: "Test User")
      vault = UserPreferences.create!(resource: user)

      user.destroy

      assert_nil UserPreferences.find_by(id: vault.id)
    end
  end
end

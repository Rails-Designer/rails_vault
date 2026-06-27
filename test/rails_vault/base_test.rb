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

class LazyDefaultsTest < ActiveSupport::TestCase
  test "returns new unsaved instance when no record exists (lazy enabled)" do
    user = LazyUser.create!(name: "Test User")

    features = user.lazy_features

    assert_not_nil features
    assert_not_predicate features, :persisted?
    assert_instance_of RailsVault::LazyFeatures, features
  end

  test "returns nil when no record exists (lazy disabled)" do
    user = User.create!(name: "Test User")

    assert_nil user.user_preferences
  end

  test "reads defaults without DB query" do
    user = LazyUser.create!(name: "Test User")

    features = user.lazy_features

    assert_equal false, features.beta_access
    assert_equal false, features.dark_mode
    assert_equal "player", features.nickname
    assert_equal false, features.beta_access?
  end

  test "creates DB record on first save" do
    user = LazyUser.create!(name: "Test User")

    features = user.lazy_features
    features.dark_mode = true
    features.save!

    assert_predicate features, :persisted?
    assert_equal true, features.dark_mode

    reloaded = RailsVault::LazyFeatures.find(features.id)
    assert_equal true, reloaded.dark_mode
  end

  test "reads defaults without creating a DB record" do
    user = LazyUser.create!(name: "Test User")

    user.lazy_features.beta_access
    user.lazy_features.dark_mode
    user.lazy_features.nickname

    assert_equal 0, RailsVault::LazyFeatures.count
  end

  test "lazy vault instance is cached across calls" do
    user = LazyUser.create!(name: "Test User")

    first_call = user.lazy_features
    second_call = user.lazy_features

    assert_same first_call, second_call
  end

  test "persisted lazy vault is cached across calls" do
    user = LazyUser.create!(name: "Test User")

    features = user.lazy_features
    features.dark_mode = true
    features.save!

    assert_same features, user.lazy_features
  end

  test "returns persisted record for new parent instance" do
    user = LazyUser.create!(name: "Test User")

    user.lazy_features.update!(dark_mode: true)

    same_user = LazyUser.find(user.id)
    reloaded = same_user.lazy_features

    assert_predicate reloaded, :persisted?
    assert_equal true, reloaded.dark_mode
  end
end

# frozen_string_literal: true

require "test_helper"

module RailsVault
  class ViewTest < ActiveSupport::TestCase
    test "returns View when vault exists" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      view = account.account_settings

      assert_instance_of View, view
    end

    test "returns nil when no vault exists" do
      account = Account.create!(name: "Test Account")

      assert_nil account.account_settings
    end

    test "reads attributes via view" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      assert_equal "dark", account.account_settings.theme
    end

    test "writes attributes via view" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      account.account_settings.theme = "light"
      account.account_settings.save!
      account.account_settings.reload

      assert_equal "light", account.account_settings.theme
    end

    test "update method works" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      result = account.account_settings.update(theme: "light")

      assert result
      account.account_settings.reload
      assert_equal "light", account.account_settings.theme
    end

    test "save method returns boolean" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account)
      view = account.account_settings

      assert view.save
    end

    test "resource returns parent model" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      assert_equal account, account.account_settings.resource
    end

    test "vault_attributes returns attribute names" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account)

      attributes = account.account_settings.vault_attributes

      assert_includes attributes, "theme"
      assert_includes attributes, "notifications"
    end

    test "reload refreshes from database" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      view = account.account_settings

      view.reload

      assert_equal "dark", view.theme
    end

    test "responds to attribute methods" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      view = account.account_settings

      assert_respond_to view, :theme
      assert_respond_to view, :theme=
      assert_respond_to view, :save
      assert_respond_to view, :update
      assert_respond_to view, :resource
      assert_respond_to view, :reload
      assert_respond_to view, :vault_attributes
    end

    test "equality with another view of same vault" do
      account = Account.create!(name: "Test Account")
      vault = AccountSettings.create!(resource: account, theme: "dark")

      view1 = account.account_settings
      view2 = vault.view

      assert_equal view1, view2
    end

    test "persisted? returns true when vault is saved" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      view = account.account_settings

      assert view.persisted?
    end

    test "new_record? returns false when vault exists" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account)

      view = account.account_settings

      refute view.new_record?
    end
  end
end
# frozen_string_literal: true

require "test_helper"

module RailsVault
  class VaultsTest < ActiveSupport::TestCase
    test "vault creates has_one association" do
      account = Account.create!(name: "Test Account")
      settings = AccountSettings.create!(resource: account, theme: "dark")

      assert_respond_to account, :account_settings
      assert_instance_of View, account.account_settings
      assert_equal settings.id, account.account_settings.vault.id
    end

    test "vault association returns vault instance" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account)

      assert_instance_of View, account.account_settings
    end

    test "vault association returns nil when no vault exists" do
      account = Account.create!(name: "Test Account")

      assert_nil account.account_settings
    end

    test "vault is dependent destroy" do
      account = Account.create!(name: "Test Account")
      vault = AccountSettings.create!(resource: account)

      account.destroy

      assert_nil AccountSettings.find_by(id: vault.id)
    end

    test "manually created vaults can be accessed" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")

      assert_equal "dark", account.account_settings.theme
    end

    test "vault with class_name option" do
      klass = Class.new(User) do
        self.table_name = "users"

        vault :my_settings, class_name: "RailsVault::AccountSettings"
      end

      Object.const_set("CustomUser", klass)

      user = CustomUser.create!(name: "Custom Test")
      RailsVault::AccountSettings.create!(resource: user, theme: "dark")

      assert_respond_to user, :my_settings
      assert_equal "dark", user.my_settings.theme

    ensure
      Object.send(:remove_const, :CustomUser) if defined?(CustomUser)
    end

    test "multiple vaults on same model are independent" do
      account = Account.create!(name: "Test Account")
      AccountSettings.create!(resource: account, theme: "dark")
      AccountBilling.create!(resource: account, plan: "premium")

      assert_equal "dark", account.account_settings.theme
      assert_equal "premium", account.account_billing.plan
    end

    test "vaults method creates multiple associations" do
      account_class = Class.new(User) do
        self.table_name = "users"

        vaults :user_preferences, :account_settings
      end

      Object.const_set("MultiVaultUser", account_class)

      user = MultiVaultUser.create!(name: "Multi Test")

      assert_respond_to user, :user_preferences
      assert_respond_to user, :account_settings

    ensure
      Object.send(:remove_const, :MultiVaultUser) if defined?(MultiVaultUser)
    end
  end
end

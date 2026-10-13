# frozen_string_literal: true

require "test_helper"
require "rails/generators/test_case"
require "generators/vault_generator"

class VaultGeneratorTest < Rails::Generators::TestCase
  tests VaultGenerator
  destination File.expand_path("../../tmp/generators", __dir__)

  setup do
    prepare_destination
    mkdir_p File.join(destination_root, "app/models")
    File.write(File.join(destination_root, "app/models/user.rb"), "class User < ApplicationRecord\nend\n")
  end

  # The generator reads the model relative to the working directory, as it
  # does when run from an app's root.
  def run_generator(*)
    Dir.chdir(destination_root) { super }
  end

  test "adds a plural vault under its own name" do
    run_generator %w[User::Preferences time_zone:string]

    assert_file "app/models/user/preferences.rb", /class User::Preferences < Vault/
    assert_file "app/models/user.rb", /^  vault :preferences$/
  end

  test "adds a singular vault under its own name so the association finds the class" do
    run_generator %w[User::Profile bio:string]

    assert_file "app/models/user/profile.rb", /class User::Profile < Vault/
    assert_file "app/models/user.rb", /^  vault :profile$/
  end

  test "adds a second vault to the existing vault line" do
    run_generator %w[User::Preferences time_zone:string]
    run_generator %w[User::Profile bio:string]

    assert_file "app/models/user.rb", /^  vaults :preferences, :profile$/
  end
end

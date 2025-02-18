# frozen_string_literal: true

require_relative "lib/rails_vault/version"

Gem::Specification.new do |spec|
  spec.name = "rails_vault"
  spec.version = RailsVault::VERSION
  spec.authors = ["Rails Designer Developers"]
  spec.email = ["devs@railsdesigner.com"]
  spec.summary = "Simple and easy to add settings, preferences and so on to any model."
  spec.description = "Rails Vault is a simple to use gem to add settings and preferences to ActiveRecord models. The settings are stored as JSON in a separate table."
  spec.homepage = "https://railsdesigner.com/rails-vault/"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Rails-Designer/rails_vault/"

  spec.files = Dir["{bin,app,config,db,lib,public}/**/*", "Rakefile", "README.md", "rails_vault.gemspec", "Gemfile", "Gemfile.lock"]

  spec.required_ruby_version = ">= 3.1.0"
  spec.add_dependency "rails", ">= 7.2.2"
  spec.add_dependency "store_attribute", ">= 1.3"
end

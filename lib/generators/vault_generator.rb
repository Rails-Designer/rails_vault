# frozen_string_literal: true

require "rails/generators"
require "rails/generators/named_base"
require_relative "vault_templates"

class VaultGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  argument :attributes, type: :array, default: [], banner: "field:type field:type"
  class_option :template, type: :string, default: nil, desc: "Use a built-in template (preferences, notification_settings, feature_flags, email_sequence)"

  def create_vault_file
    template "vault.rb.tt", File.join("app/models", class_path, "#{file_name}.rb")
  end

  def inject_vault_into_model
    has_existing_vault? ?
      gsub_file(model_path, /^\s*vaults?\s+.+$/, vault_line) :
      inject_into_class(model_path, class_name.deconstantize) { "#{vault_line}\n" }
  end

  private

  def vault_attributes
    if options[:template]
      VaultTemplates::TEMPLATES.fetch(options[:template]) do |key|
        raise ArgumentError, "Unknown template '#{key}'. Available: #{VaultTemplates::TEMPLATES.keys.join(", ")}"
      end
    else
      attributes.map { |attribute| {name: attribute.name.to_sym, type: attribute.type} }
    end
  end

  def has_existing_vault?
    model_content =~ /vaults?\s+/
  end

  def vault_line
    vaults = Set.new(model_content[/vaults?\s+(.+)$/, 1]&.scan(/:(\w+)/)&.flatten || []) << plural_name
    method_name = vaults.many? ? "vaults" : "vault"

    "  #{method_name} #{vaults.map { ":#{_1}" }.join(", ")}"
  end

  def model_content
    @model_content ||= File.binread(model_path)
  end

  def model_path
    "app/models/#{class_path.join("/")}.rb"
  end
end

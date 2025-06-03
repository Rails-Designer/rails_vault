# frozen_string_literal: true

require "rails/generators/named_base"

class VaultGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  argument :attributes, type: :array, default: [], banner: "field:type field:type"

  def create_vault_file
    template "vault.rb", File.join("app/models", class_path, "#{file_name}.rb")
  end

  def inject_vault_into_model
    has_existing_vault? ?
      gsub_file(model_path, /^\s*vaults?\s+.+$/, vault_line) :
      inject_into_class(model_path, class_name.deconstantize) { "#{vault_line}\n" }
  end

  private

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

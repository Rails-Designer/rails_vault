# frozen_string_literal: true

require "rails/generators/named_base"

module RailsVault
  module Generators
    class AddGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def create_vault_file
        template "vault.rb", File.join("app/models", class_path, "#{file_name}.rb")
      end

      def inject_vault_into_model
        parent_class = class_name.split("::").first

        inject_into_class "app/models/#{class_path.join("/")}.rb", parent_class do
          "  vault :#{plural_name}\n"
        end
      end
    end
  end
end

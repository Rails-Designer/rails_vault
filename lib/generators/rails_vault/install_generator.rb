# frozen_string_literal: true

require "rails/generators/base"

module RailsVault
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_migrations
        rails_command "railties:install:migrations FROM=rails_vault", inline: true
      end
    end
  end
end

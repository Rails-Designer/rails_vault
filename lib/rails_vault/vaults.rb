module RailsVault
  module Vaults
    extend ActiveSupport::Concern

    class_methods do
      def vault(association_name, class_name: nil, auto_create: false)
        vault_class = class_name || "#{self}::#{association_name.to_s.camelize}"

        has_one(
          association_name,
          as: :resource,
          class_name: vault_class,
          dependent: :destroy
        )

        if auto_create
          after_create -> { create_vault(association_name, vault_class) }
        end
      end

      def vaults(*association_names, auto_create_all: false)
        association_names.each do |association_name|
          vault(association_name, auto_create: auto_create_all)
        end
      end
    end

    included do
      private

      def create_vault(association_name, vault_class)
        return if public_send(association_name).present?

        vault_class.constantize.create!(resource: self)
      end
    end
  end
end

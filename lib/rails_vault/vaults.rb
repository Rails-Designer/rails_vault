module RailsVault
  module Vaults
    extend ActiveSupport::Concern

    class_methods do
      def vault(association_name, class_name: nil)
        vault_class_name = class_name || "#{self}::#{association_name.to_s.camelize}"
        vault_class = vault_class_name.safe_constantize

        has_one(
          association_name,
          as: :resource,
          class_name: vault_class_name,
          dependent: :destroy
        )

        if vault_class&.lazy?
          define_method(association_name) do
            instance_variable_get(:"@#{association_name}") ||
              instance_variable_set(
                :"@#{association_name}",
                association(association_name).scope.first || vault_class.new(resource: self)
              )
          end
        end
      end

      def vaults(*association_names)
        association_names.each do |association_name|
          vault(association_name)
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

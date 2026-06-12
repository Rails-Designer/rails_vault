module RailsVault
  module Vaults
    extend ActiveSupport::Concern

    class_methods do
      def vault(association_name, class_name: nil)
        vault_class = class_name || "#{self}::#{association_name.to_s.camelize}"

        has_one(
          association_name,
          as: :resource,
          class_name: vault_class,
          dependent: :destroy
        )

        define_method(association_name) do
          super()&.view
        end
      end

      def vaults(*association_names)
        association_names.each do |association_name|
          vault(association_name)
        end
      end
    end
  end
end

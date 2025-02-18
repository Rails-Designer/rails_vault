module RailsVault
  module Vaults
    extend ActiveSupport::Concern

    class_methods do
      def vault(association_name, class_name: nil)
        has_one association_name, as: :resource, class_name: class_name.presence || "#{self}::#{association_name.to_s.camelize}", dependent: :destroy
      end

      def vaults(*association_names)
        association_names.each do |association_name|
          has_one association_name, as: :resource, dependent: :destroy
        end
      end
    end
  end
end

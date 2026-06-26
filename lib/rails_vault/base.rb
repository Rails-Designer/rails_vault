module RailsVault
  class Base < ActiveRecord::Base
    self.table_name = "rails_vaults"

    belongs_to :resource, polymorphic: true

    class << self
      def inherited(subclass)
        super

        scope_name = subclass.name.demodulize.underscore

        subclass.vault_scope(scope_name)
      end

      def vault_scope(scope_name)
        default_scope { where(scope: scope_name) }
      end

      def vault_attribute(key, *attributes)
        options = attributes.extract_options!

        store_attribute :payload, key, *attributes, **options

        if options.key?(:default)
          @vault_defaults ||= {}

          @vault_defaults[key.to_s] = options[:default]
        end
      end

      def defaults
        @vault_defaults || {}
      end
    end

    def vault_attributes = payload.keys

    def reset(attribute = nil)
      if attribute
        key = attribute.to_s

        public_send(:"#{key}=", self.class.defaults[key]) if self.class.defaults.key?(key)
      else
        self.class.defaults.each do |key, value|
          public_send(:"#{key}=", value)
        end
      end

      self
    end

    def reset!(attribute = nil)
      reset(attribute)
      save!

      self
    end
  end
end

Vault = RailsVault::Base

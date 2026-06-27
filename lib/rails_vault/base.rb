module RailsVault
  class Base < ActiveRecord::Base
    self.table_name = "rails_vaults"

    belongs_to :resource, polymorphic: true

    class << self
      def inherited(subclass)
        super

        subclass.instance_variable_set(:@vault_defaults, {})
        subclass.instance_variable_set(:@lazy_defaults_enabled, false)

        if subclass.name
          subclass.vault_scope(subclass.name.demodulize.underscore)
        end
      end

      def vault_scope(scope_name)
        default_scope { where(scope: scope_name) }
      end

      def vault_attribute(key, *attributes)
        options = attributes.extract_options!

        @vault_defaults[key.to_s] = options[:default]

        store_attribute :payload, key, *attributes, **options
      end

      def lazy_defaults
        @lazy_defaults_enabled = true
      end

      def lazy? = @lazy_defaults_enabled

      def defaults = @vault_defaults
    end

    def vault_attributes = payload.keys
  end
end

Vault = RailsVault::Base

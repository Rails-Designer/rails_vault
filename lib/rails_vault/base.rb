module RailsVault
  class Base < ActiveRecord::Base
    self.table_name = "rails_vaults"

    belongs_to :resource, polymorphic: true

    def self.inherited(subclass)
      super
      scope_name = subclass.name.demodulize.underscore

      subclass.vault_scope(scope_name)
    end

    def self.vault_scope(scope_name)
      default_scope { where(scope: scope_name) }
    end

    def self.vault_attribute(key, *attributes)
      options = attributes.extract_options!

      store_attribute :payload, key, *attributes, **options
    end
  end
end

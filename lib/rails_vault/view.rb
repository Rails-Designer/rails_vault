# frozen_string_literal: true

module RailsVault
  class View
    attr_reader :vault

    def initialize(vault)
      @vault = vault
    end

    def save
      @vault.save
    end

    def update(attributes = {})
      @vault.update(attributes)
    end

    def resource
      @vault.resource
    end

    def vault_attributes
      @vault.vault_attributes
    end

    def reload
      @vault.reload

      self
    end

    def persisted?
      @vault.persisted?
    end

    def new_record?
      @vault.new_record?
    end

    def ==(other)
      other.is_a?(View) && @vault == other.vault
    end
    alias_method :eql?, :==

    def hash
      @vault.hash
    end

    def method_missing(name, *arguments, &block)
      @vault.public_send(name, *arguments, &block)
    end

    def respond_to_missing?(name, include_private = false)
      @vault.respond_to?(name, include_private)
    end
  end
end

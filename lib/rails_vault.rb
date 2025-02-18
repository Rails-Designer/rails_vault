# frozen_string_literal: true

require "store_attribute"
require "rails_vault/version"
require "rails_vault/engine"
require "rails_vault/base"
require "rails_vault/vaults"

module RailsVault
  class Error < StandardError; end
end

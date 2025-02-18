module RailsVault
  class Engine < ::Rails::Engine
    isolate_namespace RailsVault

    initializer "rails_vault.active_record" do
      ActiveSupport.on_load(:active_record) do
        include RailsVault::Vaults
      end
    end
  end
end

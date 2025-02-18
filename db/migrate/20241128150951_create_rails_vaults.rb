class CreateRailsVaults < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_vaults do |t|
      t.belongs_to :resource, polymorphic: true, null: false
      t.string :scope, null: false

      if t.respond_to?(:jsonb)
        t.jsonb :payload, null: false, default: {}
      else
        t.json :payload, null: false, default: {}
      end

      t.timestamps
    end

    add_index :rails_vaults, :scope
    if connection.adapter_name.downcase == "postgresql"
      add_index :rails_vaults, :payload, using: :gin
    else
      add_index :rails_vaults, :payload
    end
  end
end

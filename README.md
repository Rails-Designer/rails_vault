# rails_vault

Simple and easy to add settings, preferences and so on to any model.


**Sponsored By [Rails Designer](https://railsdesigner.com/)**

<a href="https://railsdesigner.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_vault/HEAD/.github/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Rails-Designer/rails_vault/HEAD/.github/logo-light.svg">
    <img alt="Rails Designer" src="https://raw.githubusercontent.com/Rails-Designer/rails_vault/HEAD/.github/logo-light.svg" width="240" style="max-width: 100%;">
  </picture>
</a>


## Installation

```bash
bundle add rails_vault
rails generate rails_vault:install
rails db:migrate
```


## Usage

Generate a vault:
```bash
rails generate vault MODEL::VAULT_NAME [field:type field:type]
```

Use a built-in template:
```bash
rails generate vault User::Preferences --template=preferences
```

Available templates:

| Template | Description |
|----------|-------------|
| `preferences` | Timezone, locale, date/time format, UI density, hotkeys |
| `notification_settings` | Email/push/SMS toggles, frequency, quiet hours |
| `feature_flags` | Boolean flags for A/B testing and beta features |
| `email_sequence` | State tracking for drip/welcome email sequences |


Example (manual fields):
```bash
rails generate vault User::Preferences \
  time_zone:string \
  datetime_format:string \
  hotkeys_disabled:boolean
```

This will:
1. Create a vault class at **app/models/users/preferences.rb**
2. Add `vault :preferences` to your User model


### Define vault attributes

```ruby
class User::Preferences < Vault
  vault_attribute :time_zone, :string, default: "UTC"
  vault_attribute :datetime_format, :string, default: "dd-mm-yyyy"
  vault_attribute :hotkeys_disabled, :boolean, default: false
end
```


### Read and write values

Calling `user.preferences` returns a `RailsVault::View` object that wraps the underlying vault.
```ruby
user = User.first
user.preferences.time_zone  # => "UTC"
user.preferences.hotkeys_disabled?  # => false

user.preferences.update time_zone: "Amsterdam", hotkeys_disabled: true

user.preferences.time_zone  # => "Amsterdam"
user.preferences.hotkeys_disabled?  # => true

user.preferences.vault_attributes  # => ["time_zone", "datetime_format", "hotkeys_disabled"]
user.preferences.resource  # => user
user.preferences.save
```


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `be standardrb` before submitting pull requests. Run tests via `rails test`.


## License

rails_vault is released under the [MIT License](https://opensource.org/licenses/MIT).

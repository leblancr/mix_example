import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
# Set the default timezone for your application
config :mix_example, :time_zone, "America/New_York"  # This is correct for your app

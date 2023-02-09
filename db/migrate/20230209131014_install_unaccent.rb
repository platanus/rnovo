class InstallUnaccent < ActiveRecord::Migration[6.1]
  def self.up
    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS unaccent;")
  end

  def self.down
    ActiveRecord::Base.connection.execute("DROP EXTENSION unaccent;")
  end
end

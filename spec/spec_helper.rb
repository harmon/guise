require 'loader'

Spec::Runner.configure do |config|
  config.include ActsAsFu
end

# begin
#   require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
# rescue LoadError => e
#   puts "You need to install rspec in your base app"
#   exit
# end
 
# plugin_spec_dir = File.dirname(__FILE__)
# ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

 
# databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))
# ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "sqlite3"])
# load(File.join(plugin_spec_dir, "db", "schema.rb"))


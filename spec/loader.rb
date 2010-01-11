require 'rubygems'
require 'activerecord'
require 'will_paginate'
require 'acts_as_fu'
require 'ruby-debug'

# Override acts_as_fu connection so we can direct logging to where we want.
ActiveRecord::Base.establish_connection({
  :adapter => "sqlite3",
  :database => ":memory:"
})
plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(File.open(plugin_spec_dir + "/test.log", 'a'))
ActsAsFu::Connection.connected = true


WillPaginate.enable_activerecord

# Loads all files in spec/models
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each do |f|
   require f
end

# Put this at the bottom so it doesn't load factories before the models.
require 'factory_girl'

# ARGV.shift
# debugger
require 'rubygems'
require 'factory_girl'
require 'acts_as_fu'

# Loads all files in spec/models
Dir[File.join(File.dirname(__FILE__), 'models', '*.rb')].each do |f|
   require f
end

require 'facade/base'

module Facade
	def self.included(base_class)
		base_class.class_eval do
			extend Base
		end
	end

end

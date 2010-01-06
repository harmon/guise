module Facade::Base

	def facade_list(format, params)
		
	end
	
	def facade_list_defaults(&block)
		@defaults = yield
  		@list_defaults ||= {
  			:sort => nil,
  			:dir => nil,
  			:per_page => 40
  		}
  		@list_defaults
	end
	
	def facade_list_defaults
	
	
	end


end

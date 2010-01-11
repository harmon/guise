
module Facade
    class InvalidListOptions < StandardError; end
    
    module Base
        
        def list(name, options)
            options = sanitize_options(options)
            
            options = merge_default_options(options)
            
            with_scope(:find => {:conditions => params[:conditions], :include => params[:include]}) do
    			if params[:limit] == nil
    				records, record_count = list_all(params)
    			else
    				records, record_count = list_paginated(params)
    			end					
    		end
		
    		return records, record_count
    	end
        
        def sanitize_options(options)
            options.keys.each do |key|
               unless Facade.options[:valid_find_options].include?(key) 
                   raise InvalidListOptions, "Bad key passed: #{key}"
               end
            end
        end

        def merge_default_options(options)
            {
				:conditions => params[:search] ? get_search_conditions(params[:search]) : nil,
				:include => params[:include] || get_sext_constant('SEXT_INCLUDE'),
				:start => params[:start],
				:limit => params[:list_all] ? nil : params[:limit],
				:order => sext_get_order(params[:sort], params[:dir])
			}.merge(options)
		end

        def list_options_for(name, options = {})
            write_inheritable_attribute(:list_options, {}) if list_options.nil?
            list_options[name] = Facade.options[:default_list_options].merge(options)
        end

        def list_conditions
            @list_conditions ||= FilterFoo.new
        end

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
    	
    	private
    	
    	# Determines the :order value that gets passed to #find.
		def get_list_order(sort, dir)
			if sort
				column_order_mapping = get_sext_constant('SEXT_COLUMN_ORDER_MAPPING')

				# Lookup and use the designated ordering if defined in the model.
		  		if column_order_mapping && column_order_mapping.has_key?(sort.to_sym)
		  			sort = column_order_mapping[sort.to_sym]

		  		# Use the passed in value if it looks complete with table name.
  				elsif !sort.include?('.')
					sort = [self.table_name, sort].join('.')
		  		end

				dir ||= "ASC"
		  		order = sort + " " + dir
		  	else
		  		order = get_sext_constant('SEXT_DEFAULT_SORT')
		  	end
		  	
			return order	
		end
		
		def list_options
		    read_inheritable_attribute(:list_options)		    
	    end

    end
end

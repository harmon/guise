module Facade
    class InvalidListOptions < StandardError; end
    
    module Base
        
        # Main method.
        def list(name, options = {})
            sanitize_options(options)
            
            options = merge_default_options(name, :list, options)
            
            records = nil
            record_count = nil

            with_scope(:find =>
                {
                    :conditions => options[:conditions], 
                    :include => options[:include], 
                    :joins => options[:join],
                    :order => options[:order],
                    :group => options[:group],
                    :select => options[:select],
                    :from => options[:from],
                    :readonly => options[:readonly]
                }) do
                if options[:paginate]
                    records, record_count = list_paginated(name, options)
                else
                    records, record_count = list_all(name, options)
                end
    		end
		
    		return records, record_count
    	end
        
        # Sets the default options for the scope specified by `name`
        def list_default_options(name, options = {})
            write_inheritable_attribute(:list_options, {}) if list_options.nil?
            list_options[name] = Facade.options[:default_options].merge(options)
        end

        # Used to build up #find conditions
        def list_conditions
            @list_conditions ||= FilterFoo.new
        end
    	
    	private

        # Calls the normal AR Find.
        def list_all(name, options)
            records = find(:all, :limit => options[:limit], :offset => options[:offset])
            if options[:skip_count]
                record_count = records.size
            else
		        record_count = count
	        end
	        return records, record_count
        end
        
        # Calls WillPaginate
        def list_paginated(name, options)
			options = options.slice(:page, :per_page, :order)
			options = merge_default_options(name, :pagination, options)
			result = paginate(:all, options)
			record_count = result.total_entries
			
			return result, record_count
		end
		
		# Throws InvalidListOptions if options were passed that shouldn't have been.
        def sanitize_options(options)
            options.keys.each do |key|
               unless Facade.options[:valid_find_options].include?(key) || Facade.options[:valid_list_options].include?(key)
                   raise InvalidListOptions, "Bad key passed: #{key}"
               end
            end
        end

        # Merge options for a specified name and type into the defaults and return the result.
        def merge_default_options(name, type, options = {})
            list_options[name][type].merge(options)
		end

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
		
		# Returns the default options
		def list_options
		    read_inheritable_attribute(:list_options)
	    end

    end
end

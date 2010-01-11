
module Facade
    class InvalidListOptions < StandardError; end
    
    module Base
        
        def list(name, options = {})
            sanitize_options(options)
            
            options = merge_default_options(name, options)
            
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
                    records = find(:all, :limit => options[:limit], :offset => options[:offset])
                    if options[:skip_count]
                        record_count = records.size
                    else
    			        record_count = count
			        end
    		end
		
    		return records, record_count
    	end
        
        def sanitize_options(options)
            options.keys.each do |key|
               unless Facade.options[:valid_find_options].include?(key) || Facade.options[:valid_list_options].include?(key)
                   raise InvalidListOptions, "Bad key passed: #{key}"
               end
            end
        end

        def merge_default_options(name, options = {})
                #             {
                # :conditions => params[:search] ? get_search_conditions(params[:search]) : nil,
                # :include => params[:include] || get_sext_constant('SEXT_INCLUDE'),
                # :start => params[:start],
                # :limit => params[:list_all] ? nil : params[:limit],
                # :order => sext_get_order(params[:sort], params[:dir])
            list_options[name].merge(options)
		end

        def list_default_options(name, options = {})
            write_inheritable_attribute(:list_options, {}) if list_options.nil?
            list_options[name] = Facade.options[:default_list_options].merge(options)
        end

        def list_conditions
            @list_conditions ||= FilterFoo.new
        end
    	
    	private
    	
    	# Grabs all records and a count in the context of :conditions and :include
		def list_all(options = {})
			records = find(:all, :limit => options[:limit], :offset => options[:offset], :order => options[:order])
			record_count = count(options)
			
			return records, record_count
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
		
		def list_options
		    read_inheritable_attribute(:list_options)
	    end

    end
end

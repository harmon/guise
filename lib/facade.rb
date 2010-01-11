require 'rubygems'
require 'activerecord'
require 'filter_foo'

module Facade
	def self.included(base_class)
		base_class.class_eval do
			extend Base
		end
	end
	
	class << self
       	def options
    		@options ||= {
    			:valid_find_options => [
        			:conditions, :include, :joins, :limit, :offset,
                    :order, :select, :readonly, :group, :having, :from, :lock
    			],
    			:valid_list_options => [
                    :skip_count
    			],
    			:default_list_options => {
    				:conditions => nil,
    				:include => nil,
    				:start => 1,
    				:limit => 40,
    				:order => nil
    			}
    		}
    	end
    end
    

end


require 'facade/base'
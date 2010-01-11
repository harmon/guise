require 'rubygems'
require 'activerecord'
require 'filter_foo'
require 'will_paginate'

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
                    :skip_count, :paginate
    			],
    			:default_options => {
    			    :list => {
        				:conditions => nil,
        				:include => nil,
        				:start => 1,
        				:limit => 40,
        				:order => nil
        			},
        			:pagination => {
        			    :per_page => 40,
        			    :page => 1
        			}
    			}
    		}
    	end
    end
end


require 'facade/base'
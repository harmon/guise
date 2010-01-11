# The MIT License
# 
# Copyright (c) 2007 Davide D'Agostino, Adam Grant
#
# Original: http://lipsiasoft.googlecode.com/svn/trunk/filter/
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# ====================================
#             FilterFoo
# ====================================
#
# FilterFoo lets you specify common filtering options, in order to generate
# a filtered condition, useful for filtering from request params.
#
# Example usage:
#   @filter = Filter.new
#   @filter.multiple params[:type][:id], "type_id"
#
# 	@filter.or do |f|
#			 f.equal(params[:name], "name_id")
#			 f.equal(params[:company], "company_id")
#	end
#
#   @people = People.find(:all, :conditions => @filter.conditions)
#   
#   # Generates: SELECT * FROM people WHERE (type_id IN (1,2) AND (name_id = 3 OR company_id = 23))
class FilterFoo
  attr_accessor :filters
  # Instantiate a new filter using the data hash as base.
  def initialize
    @filters = Array.new
    @ors = Array.new
    @yielded = false
  end

  # Defines a filter that accepts multiple values.
  # This will match against the filtered column looking for ANY of the values in the key.
  #
  # Example:
  #   # This will match all the objects that have type_id = 1 OR type_id = 2
  #   @filter = Filter.new 
  #   @filter.multiple "1,2", 'type_id'
  # 	# => ["type_id IN (?)", "1,2"]
  def multiple(key, filtered)
    key = key.to_s 
    if @yielded == false
    	@filters << ["#{filtered} IN (?)", key] unless key.blank?
  	else
  		@ors << ["#{filtered} IN (?)", key] unless key.blank?
  	end
  	return
  end

  # Defines a filtering that checks for equality.
  #
  # Example:
  #   @filter = Filter.new
  #   @filter.equal params[:id], 'an_id'
  # 	# => ["an_id = ?", params[:id]]
  def equal(key, filtered)
    key = key.to_s
    if @yielded == false
    	@filters << ["#{filtered} = ?", key] unless key.blank?
  	else
  		@ors << ["#{filtered} = ?", key] unless key.blank?
  	end
  	return
  end

  # Defines a filtering that checks for great.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.great :other_id, 'an_id'
  # 	# => ["an_id > ?", :other_id]
  def great(key, filtered)
    key = key.to_s
   	if @yielded == false
    	@filters << ["#{filtered} > ?", key] unless key.blank?
  	else
  		@ors << ["#{filtered} > ?", key] unless key.blank?
  	end
  	return
  end
  
  # Defines a filtering that checks for great.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.great :other_id, 'an_id'
  # 	# => ["an_id >= ?", :other_id]
  def great_equal(key, filtered)
    key = key.to_s
   	if @yielded == false
    	@filters << ["#{filtered} >= ?", key] unless key.blank?
  	else
  		@ors << ["#{filtered} >= ?", key] unless key.blank?
  	end
  	return
  end

  # Defines a filtering that checks for less.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.less :other_id, 'an_id'
  # 	# => ["an_id < ?", :other_id]
  def less(key, filtered)
    key = key.to_s  
    if @yielded == false
    	@filters << ["#{filtered} < ?", key] unless key.blank?
  	else
  		@ors << ["#{filtered} < ?", key] unless key.blank?
  	end
  	return
  end
  
  # Defines a filtering that checks for great.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.great :other_id, 'an_id'
  # 	# => ["an_id >= ?", :other_id]
  def less_equal(key, filtered)
    key = key.to_s
   	if @yielded == false
    	@filters << ["#{filtered} <= ?", key] unless key.blank?
  	else
  		@ors << ["#{filtered} <= ?", key] unless key.blank?
  	end
  	return
  end
	# Defines a filtering that checks for not.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.isnot :other_id, 'an_id'
  # 	# => ["an_id != ?", :other_id]
	def isnot(key, filtered) 
		key = key.to_s
		if @yielded == false
    	    @filters << ["#{filtered} != ?", key] unless key.blank?
  	    else
  		    @ors << ["#{filtered} != ?", key] unless key.blank?
  	    end
  	    return
	end
	
	# Defines a filtering that checks for likeness.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.like :other_id, 'an_id'
  # 	# => ["an_id != ?", :other_id]
	def like(key, filtered) 
		if @yielded == false
        	@filters << ["#{filtered} LIKE ?", "%" + key + "%"] unless key.blank?
      	else
      		@ors << ["#{filtered} LIKE ?", "%" + key + "%"] unless key.blank?
      	end
      	return
	end
	
	# Defines a filter that checks if its included.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.in :other_id, 'an_id'
  # 	# => ["an_id != ?", :other_id]
	def in(key, filtered) 
		if @yielded == false
        	@filters << ["#{filtered} IN (?)", key] unless key.blank?
      	else
      		@ors << ["#{filtered} IN (?)", key] unless key.blank?
      	end
      	return
	end
	
  # Defines a filter that checks if its included.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.in :other_id, 'an_id'
  # 	# => ["an_id != ?", :other_id]
	def is_null(filtered) 
		if @yielded == false
    		@filters << ["#{filtered} IS NULL"]
  		else
  			@ors << ["#{filtered} IS NULL"]
  		end
  		return
	end
	
	  # Defines a filter that checks if its included.
  #
  # Example:
  #   @filter = Filter.new 
  #   @filter.in :other_id, 'an_id'
  # 	# => ["an_id != ?", :other_id]
	def add(filter) 
		if @yielded == false
    		@filters << ["#{filter}"]
  		else
  			@ors << ["#{filter}"]
  		end
  		return
	end
	
	
  # Generate an ActiveRecord prepared condition using the specified filters.
  # Used to scope the query.
  #
  # Example:
  #   People.find(:all, :conditions => @filter.conditions)
  #
  # If the filter is empty, this method will return nil, which will be ignored by AR.
  #
  def conditions
      unless self.empty?
          @filters.inject([""]) do |condition,filter|
              filter = filter.dup
              condition.first << " AND " unless condition.first.empty?
              condition.first << filter.shift
              condition += filter
          end
      end
  end
  
  # Adds in parenthesized blocks of conditions joined by ' OR ' conditions.
  #
  # Example:
  #   @filter = Filter.new 
  #
  #   @f.equal(@params[:id_1], "1_id")
	#
	# 	@f.or do |f|
	#			 f.equal(@params[:id_2], "2_id")
  #			 f.equal(@params[:id_3], "3_id")
	#		end
  #
  #		@f.equal(@params[:id_4], "4_id")
	#
  #		@f.conditions 
  #   # => ["1_id = ? AND (2_id = ? OR 3_id = ?) AND 4_id = ?", "1", "2", "3", "4"]
  #
  def or
		@yielded = true
		yield(self)
  	unless @ors.empty? 
  		@filters << ors_conditions
		    end
		@yielded = false
		@ors = []
	end
    
  # Returns true or false for whether this filter is empty or not.
  #
  # Example:
  #   @filter = Filter.new nil
  #   @filter.empty?  # => true
  #
  #   @filter = Filter.new {}
  #   @filter.empty?  # => true
  #
  #   @filter = Filter.new :foo => 'bar'
  #   @filter.empty?  # => false
  def empty?
    @filters.nil? or @filters.empty?
  end
  
  private
  
	def ors_conditions
  	@ors = @ors.inject([""]) do |condition,filter|
  		filter = filter.dup
  	  condition.first << " OR " unless condition.first.empty?
  	  condition.first << filter.shift
  	  condition += filter
  	end
  	@ors[0] = "(" + @ors[0] + ")"
    return @ors
  end
end

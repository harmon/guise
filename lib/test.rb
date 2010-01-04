require 'rubygems'
require 'activesupport'
#require 'role'
require 'ruby-debug'

class Role
	class_inheritable_accessor :permissions
#	@@permissions = 'hello'
#	@permissions = 'hello'
#	attr_accessor :permissions
#	def self.permissions
#		@permissions ||= {}	
#	end

#	def self.permissions=(new_perms)
#		permissions = new_perms
#	end
	self.permissions = {}
	
#	@wowzers = "hello"
	class << self
#		attr_accessor :wowzers
#		@wowzers = "grrrr"
#		@permissions = {}	
#		def permissions
#			@permissions ||= {}	
#		end

#		def permissions=(new_perms)
#			permissions = new_perms
#		end

#		def inherited(child_class)
#			child_class.permissions = self.permissions.dup
#		end
		
		def get_permission(resource, permission)
			perm = self.permissions[resource][permission.to_sym] if self.permissions[resource]
			perm ? perm : false
		end

		private
		
		def permissions_for(resource, new_permissions = {})
			self.permissions[resource] = (self.permissions[resource] ||= {}).merge!(new_permissions)
		end
	end
	
	permissions_for :admin, {:view => false}
end

class A < Role
	permissions_for :admin, {:view => true}
end

puts Role.permissions.inspect
puts A.permissions.inspect
#class Guest < Role
#   permissions_for :users, {:view => true, :edit => false}
#end

#class Admin < Guest
#    permissions_for :users, {:edit => true}
#end

#puts Guest.get_permission(:users, :view)        #=> true
#puts Guest.get_permission(:users, :edit)         #=> false

#puts Admin.permissions.inspect

#puts Admin.get_permission(:users, :view)        #=> true
#puts Admin.get_permission(:users, :edit)         #=> true







#class A < Role
#	permissions_for :admin, {:all => true}
#end

#class B < A
#	permissions_for :admin, {:all => false}
#	permissions_for :super_admin, {:all => true}
#end

#puts A.permissions.inspect
#puts B.permissions.inspect

















#Guise.add_role(:user, MyRole)

#module Guise

##	mattr_accessor :roles
##	@@roles = {:peter => 'hello'}

##	mattr_accessor :default_role
##	@@default_role = self
#	
#	class << self
##		attr_accessor :roles
#		
#		# Adds a new role to the roles hash. Takes a :role_name and a RoleClass constant.
#		def add_role(role_name, role_class)
#			roles[role_name.to_s.to_sym] = role_class
#		end
#		
#		def roles
#			@@roles ||= {}
#		end
#		
##		def show_roles
##			puts @@roles.inspect
##		end
#		
#	end
#	
#	class Role
#		
#		
#		class << self

##			attr_accessor :permissions
#			
##			def inherited(child_class)
##				puts "Adding Role: #{child.to_s}"
##			end
#			def wow
#				hello
#			end

#			private
#			
#			def hello
#				puts "wowwy!"
#			end

#		end
#		
#	end
#	
#end


#Guise.add_role(:wow, "ooch!")
#puts Guise.roles.inspect
#Guise::Role.hello

require 'activesupport'

module Guise

	class << self
		def roles
			@@roles ||= {}
		end

		def get_roles_list
			roles.map {|key,| key.to_s }
		end

		# Adds a new role to the roles hash. Takes a :role_name and a RoleClass constant.
		def add_role(role_name, role_class)
			roles[role_name.to_s.downcase.to_sym] = role_class
		end

		def default_role
			@@default_role
		end
		
		def default_role=(role)
			@@default_role = role
		end

		# Looks up a role in the roles hash. Raises RoleNotFound if none was found.
		def find_role(role_name)
			return nil if role_name.blank?
			role = roles[role_name.to_s.downcase.to_sym]
			unless role
				raise RoleNotFound, "Role with name #{role_name} could not be found in Roles: #{roles.inspect}"
			end
			role
		end
	end
	
	class Role
			def self.permissions
#				puts "#{self.to_s} - #{@permissions.inspect}"				
				@permissions ||= {}	
			end
			def self.permissions=(new_permissions)
				permissions = new_permissions
			end
	
		class << self

#			attr_accessor :permissions

			
			def inherited(child_class)
				puts "Adding Role: #{child_class.to_s}"
				Guise.add_role(child_class.to_s.underscore, child_class)
				child_class.permissions = permissions.dup
			end
			
			# Finds the specified `permission` for the `resource`.	
			def get_permission(resource, permission)
				perm = resource_permission(resource)[permission.to_sym]
				perm.present? ? perm : false
			end

			private
			
			def resource_permission(resource)
				permissions[resource.to_sym] ||= {}
			end

			# Sets the permissions for the named resource.
			def permissions_for(resource, new_permissions = {})
#				debugger
				resource_permission(resource).merge!(new_permissions)
			end

		end
		
	end
end

#Guise.initialize_roles

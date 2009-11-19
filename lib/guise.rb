module Guise
	class RoleNotFound < StandardError; end
		
	DEFAULT_ROLES_FOLDER = File.join(RAILS_ROOT, "app", "models", "roles", "*.rb")
	
	mattr_accessor :roles
	self.roles = {}
	
	def self.initialize_roles(path_to_roles = DEFAULT_ROLES_FOLDER)
		Dir[path_to_roles].each {|file| require file}
	end
	
	def self.included(base_class)
		base_class.class_eval do
			extend ClassMethods
		end
	end
	
	module ClassMethods
		# Adds a new role to the roles hash. Takes a :role_name and a RoleClass constant.
		def add_role(role_name, role_class)
			roles[role_name.to_s.underscore.to_sym] = role_class
		end
		
		# Default role. Nuff said.
		def default_role
			BasicUserRole
		end

		# Looks up a role in the roles hash. Raises RoleNotFound if none was found.
		def find(role_name)
			return nil if role_name.blank?
			role = roles[role_name.to_sym]
			unless role
				raise RoleNotFound, "Role with name #{role_name} could not be found: Roles = #{roles.inspect}"
			end
			role
		end

		# Finds the specified `permission` for the `resource`.	
		def get_permission(resource, permission)
			perm = permissions[resource.to_sym][permission.to_sym] if permissions[resource.to_sym]
			perm || false
		end
		
		def inherited(child)
			puts "Adding Role: #{child.to_s}"
			add_role(child.to_s.underscore, child)
		end

		# Returns the hash of permissions.
		def permissions
			@permissions ||= {}
		end
		
		# Returns the roles hash.
		def roles
			Guise.roles
		end
		
		def get_roles_list
			roles.map {|key,| key.to_s }
		end
		
		private

		# Sets the permissions for the named resource.
		def permissions_for(resource, new_permissions = {})
			old_perms = permissions[resource.to_sym] || {}
			permissions[resource.to_sym] = old_perms.merge(new_permissions)
		end

	end
	
end

Guise.initialize_roles

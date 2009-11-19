# Thrown if a named role isn't found.
	
# Master class that all roles should subclass. Subclasses should define their
# role permissions as follows:
#
#	class Guest < Role
#		permissions_for :receipt, {
#			:create => false,
#			:read => true
#		}
#
#		permissions_for :line_items, { :view_report => true, :email => true	}
#		
#		etc...	
#	end
#
#===============================================================================
#	Example Usage:
#
#		@user = User.find(params[:id])
#		@user.role 									#=> :guest
#		@user.has_permission?(:receipt, :create) 	#=> true/false
#
#===============================================================================
#	Where is this used?
#	
#		class Receipt
# 			def updateable_by?(user)
# 				user.has_permission?(:receipt, :update)
#			end
#		...
#
#		class ReceiptController < ActionController::Base
#			before_filter :check_permission, :only => [:create]
#
#			private
# 			def check_permission
# 				current_user.has_permission(:receipt, :create)
#			end
#		...
#
	
class GuiseRole
	include Guise
end


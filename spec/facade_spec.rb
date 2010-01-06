puts "ARG"
require File.dirname(__FILE__) + '/spec_helper'  
require 'lib/facade'

describe "Facade" do  
	
	before(:all) do
#		Factor
	end
	
	it "should have a pending spec" do
		User.count.should == 0
	end
end  

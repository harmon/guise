puts "ARG"
require File.dirname(__FILE__) + '/spec_helper'  
require 'facade'

describe Facade do  
  
  before(:all) do
  end
  
    it "should have a pending spec" do
        User.count.should == 0
    end
  
    it "should have valid_find_options" do
        Facade.options.has_key?(:valid_find_options).should == true
    end
    
    it "should sanitize the passed in options hash" do
        invalid_options = {:tweedle_dee => 'tweedle_dumb', :edgar_allen => 'poe'}
        lambda {
            User.list(:normal, invalid_options)
        }.should raise_error(Facade::InvalidListOptions)
    end
end  

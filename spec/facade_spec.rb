puts "ARG"
require File.dirname(__FILE__) + '/spec_helper'  
require 'facade'

describe Facade do  
  
  before(:all) do
      User.delete_all
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
            User.list(:default, invalid_options)
        }.should raise_error(Facade::InvalidListOptions)
    end
    
    describe "When finding records" do
        before(:each) do
            User.delete_all
            Factory.create :user, :name => 'John Jackson'
            Factory.create :user, :name => 'Ted Jackson'
            Factory.create :user, :name => 'Mikey Jackson'
        end
        
        it "should find three users" do
            @users, @count = User.list(:default)
            @users.size.should == 3
            @count.should == 3
        end
        
        it "should paginate the users" do
            @users, @count = User.list(:default, :paginate => {:per_page => 3})
            puts @users.class.inspect
            @users.size.should == 3
            @count.should == 3
        end
    end
end  

require 'facade'
build_model :user do
    string :name
    string :email
    string :address
    string :city
    
    include Facade
    
    list_default_options :default, {
        :skip_count => true
    }
  
#    User.list(:limit => 5, :paginate => {:page => , :per_page => }, :search => 'term')
    
    
  
end

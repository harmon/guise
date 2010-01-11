require 'facade'
build_model :user do
    string :name
    string :email
    string :address
    string :city
    
    include Facade
    list_options_for :normal, {
                
    }
  
    
  
end

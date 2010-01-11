require 'facade'

build_model :user do
    string :name
    string :email
    string :address
    string :city
    
    include Facade
    
    list_default_options :default, {
        :list => {
            :skip_count => true
        },
        :pagination => {
            :per_page => 40,
            :page => 1
        }
    }
end

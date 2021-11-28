lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib)

require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
  attribute :zip, Shale::Type::String
  attribute :state, Shale::Type::String
  attribute :state_abbr, Shale::Type::String
  attribute :country, Shale::Type::String
  attribute :country_code, Shale::Type::String
  attribute :time_zone, Shale::Type::String
  attribute :latitude, Shale::Type::String
  attribute :longitude, Shale::Type::String
end

class Contact < Shale::Mapper
  attribute :type, Shale::Type::String
  attribute :contact, Shale::Type::String
end

class Company < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :industry, Shale::Type::String
  attribute :ein, Shale::Type::String
  attribute :type, Shale::Type::String
  attribute :address, Address
  attribute :contacts, Contact, collection: true

  xml do
    root 'company'
    map_element 'name', to: :name
    map_element 'industry', to: :industry
    map_element 'ein', to: :ein
    map_element 'type', to: :type
    map_element 'address', to: :address
    map_element 'contact', to: :contacts
  end
end

class Car < Shale::Mapper
  attribute :model, Shale::Type::String
  attribute :brand, Shale::Type::String
  attribute :manufacturer, Company
end

class BankAccount < Shale::Mapper
  attribute :number, Shale::Type::String
  attribute :balance, Shale::Type::String
  attribute :bank, Company
end

class School < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address
  attribute :contacts, Contact, collection: true

  xml do
    root 'school'
    map_element 'name', to: :name
    map_element 'address', to: :address
    map_element 'contact', to: :contacts
  end
end

class Job < Shale::Mapper
  attribute :title, Shale::Type::String
  attribute :field, Shale::Type::String
  attribute :seniority, Shale::Type::String
  attribute :position, Shale::Type::String
  attribute :employment_type, Shale::Type::String
  attribute :company, Company
end

class Animal < Shale::Mapper
  attribute :kind, Shale::Type::String
  attribute :breed, Shale::Type::String
  attribute :name, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :middle_name, Shale::Type::String
  attribute :prefix, Shale::Type::String
  attribute :date_of_birth, Shale::Type::String
  attribute :place_of_birth, Address
  attribute :driving_license, Shale::Type::String
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :education, School, collection: true
  attribute :current_address, Address
  attribute :past_addresses, Address, collection: true
  attribute :contacts, Contact, collection: true
  attribute :bank_acocunt, BankAccount
  attribute :current_car, Car
  attribute :cars, Car, collection: true
  attribute :current_job, Job
  attribute :jobs, Job, collection: true
  attribute :pets, Animal, collection: true
  attribute :children, Person, collection: true

  xml do
    root 'person'
    map_element 'first_name', to: :first_name
    map_element 'last_name', to: :last_name
    map_element 'middle_name', to: :middle_name
    map_element 'prefix', to: :prefix
    map_element 'date_of_birth', to: :date_of_birth
    map_element 'place_of_birth', to: :place_of_birth
    map_element 'driving_license', to: :driving_license
    map_element 'hobby', to: :hobbies
    map_element 'school', to: :education
    map_element 'current_address', to: :current_address
    map_element 'past_address', to: :past_addresses
    map_element 'contact', to: :contacts
    map_element 'bank_acocunt', to: :bank_acocunt
    map_element 'current_car', to: :current_car
    map_element 'car', to: :cars
    map_element 'current_job', to: :current_job
    map_element 'job', to: :jobs
    map_element 'pet', to: :pets
    map_element 'child', to: :children
  end
end

class Report < Shale::Mapper
  attribute :people, Person, collection: true

  xml do
    root 'people'
    map_element 'person', to: :people
  end
end

lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib)

require 'shale'
require_relative 'models'

class AddressMapper < Shale::Mapper
  model Address

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

class ContactMapper < Shale::Mapper
  model Contact

  attribute :type, Shale::Type::String
  attribute :contact, Shale::Type::String
end

class CompanyMapper < Shale::Mapper
  model Company

  attribute :name, Shale::Type::String
  attribute :industry, Shale::Type::String
  attribute :ein, Shale::Type::String
  attribute :type, Shale::Type::String
  attribute :address, AddressMapper
  attribute :contacts, ContactMapper, collection: true

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

class CarMapper < Shale::Mapper
  model Car

  attribute :model, Shale::Type::String
  attribute :brand, Shale::Type::String
  attribute :manufacturer, CompanyMapper
end

class BankAccountMapper < Shale::Mapper
  model BankAccount

  attribute :number, Shale::Type::String
  attribute :balance, Shale::Type::String
  attribute :bank, CompanyMapper
end

class SchoolMapper < Shale::Mapper
  model School

  attribute :name, Shale::Type::String
  attribute :address, AddressMapper
  attribute :contacts, ContactMapper, collection: true

  xml do
    root 'school'
    map_element 'name', to: :name
    map_element 'address', to: :address
    map_element 'contact', to: :contacts
  end
end

class JobMapper < Shale::Mapper
  model Job

  attribute :title, Shale::Type::String
  attribute :field, Shale::Type::String
  attribute :seniority, Shale::Type::String
  attribute :position, Shale::Type::String
  attribute :employment_type, Shale::Type::String
  attribute :company, CompanyMapper
end

class AnimalMapper < Shale::Mapper
  model Animal

  attribute :kind, Shale::Type::String
  attribute :breed, Shale::Type::String
  attribute :name, Shale::Type::String
end

class PersonMapper < Shale::Mapper
  model Person

  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :middle_name, Shale::Type::String
  attribute :prefix, Shale::Type::String
  attribute :date_of_birth, Shale::Type::String
  attribute :place_of_birth, AddressMapper
  attribute :driving_license, Shale::Type::String
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :education, SchoolMapper, collection: true
  attribute :current_address, AddressMapper
  attribute :past_addresses, AddressMapper, collection: true
  attribute :contacts, ContactMapper, collection: true
  attribute :bank_acocunt, BankAccountMapper
  attribute :current_car, CarMapper
  attribute :cars, CarMapper, collection: true
  attribute :current_job, JobMapper
  attribute :jobs, JobMapper, collection: true
  attribute :pets, AnimalMapper, collection: true
  attribute :children, PersonMapper, collection: true

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

class ReportMapper < Shale::Mapper
  model Report

  attribute :people, PersonMapper, collection: true

  xml do
    root 'people'
    map_element 'person', to: :people
  end
end

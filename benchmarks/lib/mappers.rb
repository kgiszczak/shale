require 'shale'
require_relative 'models'

class AddressMapper < Shale::Mapper
  model Address

  attribute :city, Shale::Type::Value
  attribute :street, Shale::Type::Value
  attribute :zip, Shale::Type::Value
  attribute :state, Shale::Type::Value
  attribute :state_abbr, Shale::Type::Value
  attribute :country, Shale::Type::Value
  attribute :country_code, Shale::Type::Value
  attribute :time_zone, Shale::Type::Value
  attribute :latitude, Shale::Type::Value
  attribute :longitude, Shale::Type::Value
end

class ContactMapper < Shale::Mapper
  model Contact

  attribute :type, Shale::Type::Value
  attribute :contact, Shale::Type::Value
end

class CompanyMapper < Shale::Mapper
  model Company

  attribute :name, Shale::Type::Value
  attribute :industry, Shale::Type::Value
  attribute :ein, Shale::Type::Value
  attribute :type, Shale::Type::Value
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

  attribute :model, Shale::Type::Value
  attribute :brand, Shale::Type::Value
  attribute :manufacturer, CompanyMapper
end

class BankAccountMapper < Shale::Mapper
  model BankAccount

  attribute :number, Shale::Type::Value
  attribute :balance, Shale::Type::Value
  attribute :bank, CompanyMapper
end

class SchoolMapper < Shale::Mapper
  model School

  attribute :name, Shale::Type::Value
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

  attribute :title, Shale::Type::Value
  attribute :field, Shale::Type::Value
  attribute :seniority, Shale::Type::Value
  attribute :position, Shale::Type::Value
  attribute :employment_type, Shale::Type::Value
  attribute :company, CompanyMapper
end

class AnimalMapper < Shale::Mapper
  model Animal

  attribute :kind, Shale::Type::Value
  attribute :breed, Shale::Type::Value
  attribute :name, Shale::Type::Value
end

class PersonMapper < Shale::Mapper
  model Person

  attribute :first_name, Shale::Type::Value
  attribute :last_name, Shale::Type::Value
  attribute :middle_name, Shale::Type::Value
  attribute :prefix, Shale::Type::Value
  attribute :date_of_birth, Shale::Type::Value
  attribute :place_of_birth, AddressMapper
  attribute :driving_license, Shale::Type::Value
  attribute :hobbies, Shale::Type::Value, collection: true
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
    root 'report'
    map_element 'person', to: :people
  end
end

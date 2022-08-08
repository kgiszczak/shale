require 'representable/json'
require_relative 'models'

class AddressRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :city
  property :street
  property :zip
  property :state
  property :state_abbr
  property :country
  property :country_code
  property :time_zone
  property :latitude
  property :longitude
end

class ContactRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :type
  property :contact
end

class CompanyRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :name
  property :industry
  property :ein
  property :type
  property :address, decorator: AddressRepresenterJSON, class: Address
  collection :contacts, decorator: ContactRepresenterJSON, class: Contact
end

class CarRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :model
  property :brand
  property :manufacturer, decorator: CompanyRepresenterJSON, class: Company
end

class BankAccountRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :number
  property :balance
  property :bank, decorator: CompanyRepresenterJSON, class: Company
end

class SchoolRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :name
  property :address, decorator: AddressRepresenterJSON, class: Address
  collection :contacts, decorator: ContactRepresenterJSON, class: Contact
end

class JobRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :title
  property :field
  property :seniority
  property :position
  property :employment_type
  property :company, decorator: CompanyRepresenterJSON, class: Company
end

class AnimalRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :kind
  property :breed
  property :name
end

class PersonRepresenterJSON < Representable::Decorator
  include Representable::JSON

  property :first_name
  property :last_name
  property :middle_name
  property :prefix
  property :date_of_birth
  property :place_of_birth, decorator: AddressRepresenterJSON, class: Address
  property :driving_license
  collection :hobbies
  collection :education, decorator: SchoolRepresenterJSON, class: School
  property :current_address, decorator: AddressRepresenterJSON, class: Address
  collection :past_addresses, decorator: AddressRepresenterJSON, class: Address
  collection :contacts, decorator: ContactRepresenterJSON, class: Contact
  property :bank_acocunt, decorator: BankAccountRepresenterJSON, class: BankAccount
  property :current_car, decorator: CarRepresenterJSON, class: Car
  collection :cars, decorator: CarRepresenterJSON, class: Car
  property :current_job, decorator: JobRepresenterJSON, class: Job
  collection :jobs, decorator: JobRepresenterJSON, class: Job
  collection :pets, decorator: AnimalRepresenterJSON, class: Animal
  collection :children, decorator: PersonRepresenterJSON, class: Person
end

class ReportRepresenterJSON < Representable::Decorator
  include Representable::JSON

  collection :people, decorator: PersonRepresenterJSON, class: Person
end

# --------------------------------------------------------------------

class AddressRepresenterXML < Representable::Decorator
  include Representable::XML

  property :city
  property :street
  property :zip
  property :state
  property :state_abbr
  property :country
  property :country_code
  property :time_zone
  property :latitude
  property :longitude
end

class ContactRepresenterXML < Representable::Decorator
  include Representable::XML

  property :type
  property :contact
end

class CompanyRepresenterXML < Representable::Decorator
  include Representable::XML

  property :name
  property :industry
  property :ein
  property :type
  property :address, decorator: AddressRepresenterXML, class: Address
  collection :contacts, decorator: ContactRepresenterXML, class: Contact, as: 'contact'
end

class CarRepresenterXML < Representable::Decorator
  include Representable::XML

  property :model
  property :brand
  property :manufacturer, decorator: CompanyRepresenterXML, class: Company
end

class BankAccountRepresenterXML < Representable::Decorator
  include Representable::XML

  property :number
  property :balance
  property :bank, decorator: CompanyRepresenterXML, class: Company
end

class SchoolRepresenterXML < Representable::Decorator
  include Representable::XML

  property :name
  property :address, decorator: AddressRepresenterXML, class: Address
  collection :contacts, decorator: ContactRepresenterXML, class: Contact, as: 'contact'
end

class JobRepresenterXML < Representable::Decorator
  include Representable::XML

  property :title
  property :field
  property :seniority
  property :position
  property :employment_type
  property :company, decorator: CompanyRepresenterXML, class: Company
end

class AnimalRepresenterXML < Representable::Decorator
  include Representable::XML

  property :kind
  property :breed
  property :name
end

class PersonRepresenterXML < Representable::Decorator
  include Representable::XML

  property :first_name
  property :last_name
  property :middle_name
  property :prefix
  property :date_of_birth
  property :place_of_birth, decorator: AddressRepresenterXML, class: Address
  property :driving_license
  collection :hobbies, as: 'hobby'
  collection :education, decorator: SchoolRepresenterXML, class: School, as: 'school'
  property :current_address, decorator: AddressRepresenterXML, class: Address
  collection :past_addresses, decorator: AddressRepresenterXML, class: Address, as: 'past_address'
  collection :contacts, decorator: ContactRepresenterXML, class: Contact, as: 'contact'
  property :bank_acocunt, decorator: BankAccountRepresenterXML, class: BankAccount
  property :current_car, decorator: CarRepresenterXML, class: Car
  collection :cars, decorator: CarRepresenterXML, class: Car, as: 'car'
  property :current_job, decorator: JobRepresenterXML, class: Job
  collection :jobs, decorator: JobRepresenterXML, class: Job, as: 'job'
  collection :pets, decorator: AnimalRepresenterXML, class: Animal, as: 'pet'
  collection :children, decorator: PersonRepresenterXML, class: Person, as: 'child'
end

class ReportRepresenterXML < Representable::Decorator
  include Representable::XML

  collection :people, decorator: PersonRepresenterXML, class: Person, as: 'person'
end

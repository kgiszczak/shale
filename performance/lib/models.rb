class Address
  attr_accessor :city, :street, :zip, :state, :state_abbr,
    :country, :country_code, :time_zone, :latitude, :longitude

  def initialize(city: nil, street: nil, zip: nil, state: nil, state_abbr: nil,
    country: nil, country_code: nil, time_zone: nil, latitude: nil, longitude: nil)
    @city = city
    @street = street
    @zip = zip
    @state = state
    @state_abbr = state_abbr
    @country = country
    @country_code = country_code
    @time_zone = time_zone
    @latitude = latitude
    @longitude = longitude
  end
end

class Contact
  attr_accessor :type, :contact

  def initialize(type: nil, contact: nil)
    @type = type
    @contact = contact
  end
end

class Company
  attr_accessor :name, :industry, :ein, :type, :address, :contacts

  def initialize(name: nil, industry: nil, ein: nil, type: nil, address: nil, contacts: nil)
    @name = name
    @industry = industry
    @ein = ein
    @type = type
    @address = address
    @contacts = contacts
  end
end

class Car
  attr_accessor :model, :brand, :manufacturer

  def initialize(model: nil, brand: nil, manufacturer: nil)
    @model = model
    @brand = brand
    @manufacturer = manufacturer
  end
end

class BankAccount
  attr_accessor :number, :balance, :bank

  def initialize(number: nil, balance: nil, bank: nil)
    @number = number
    @balance = balance
    @bank = bank
  end
end

class School
  attr_accessor :name, :address, :contacts

  def initialize(name: nil, address: nil, contacts: nil)
    @name = name
    @address = address
    @contacts = contacts
  end
end

class Job
  attr_accessor :title, :field, :seniority, :position, :employment_type, :company

  def initialize(title: nil, field: nil, seniority: nil, position: nil, employment_type: nil, company: nil)
    @title = title
    @field = field
    @seniority = seniority
    @position = position
    @employment_type = employment_type
    @company = company
  end
end

class Animal
  attr_accessor :kind, :breed, :name

  def initialize(kind: nil, breed: nil, name: nil)
    @kind = kind
    @breed = breed
    @name = name
  end
end

class Person
  attr_accessor :first_name, :last_name, :middle_name, :prefix, :date_of_birth,
    :place_of_birth, :driving_license, :hobbies, :education, :current_address,
    :past_addresses, :contacts, :bank_acocunt, :current_car, :cars, :current_job,
    :jobs, :pets, :children

  def initialize(first_name: nil, last_name: nil, middle_name: nil, prefix: nil, date_of_birth: nil,
    place_of_birth: nil, driving_license: nil, hobbies: nil, education: nil, current_address: nil,
    past_addresses: nil, contacts: nil, bank_acocunt: nil, current_car: nil, cars: nil, current_job: nil,
    jobs: nil, pets: nil, children: nil)
    @first_name = first_name
    @last_name = last_name
    @middle_name = middle_name
    @prefix = prefix
    @date_of_birth = date_of_birth
    @place_of_birth = place_of_birth
    @driving_license = driving_license
    @hobbies = hobbies
    @education = education
    @current_address = current_address
    @past_addresses = past_addresses
    @contacts = contacts
    @bank_acocunt = bank_acocunt
    @current_car = current_car
    @cars = cars
    @current_job = current_job
    @jobs = jobs
    @pets = pets
    @children = children
  end
end

class Report
  attr_accessor :people

  def initialize(people: nil)
    @people = people
  end
end

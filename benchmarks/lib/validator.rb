module Validator
  class << self
    def validate!(hand, shale)
      valid?(hand.people.length, shale.people.length)

      hand.people.each_with_index do |hand_person, idx|
        validate_person(hand_person, shale.people[idx])
      end
    end

    def validate_person(hand, shale)
      valid?(hand.first_name, shale.first_name)
      valid?(hand.last_name, shale.last_name)
      valid?(hand.middle_name, shale.middle_name)
      valid?(hand.prefix, shale.prefix)
      valid?(hand.date_of_birth, shale.date_of_birth)
      validate_address(hand.place_of_birth, shale.place_of_birth)
      valid?(hand.driving_license, shale.driving_license)
      valid?(hand.hobbies, shale.hobbies)

      valid?(hand.education.length, shale.education.length)
      hand.education.each_with_index do |hand_school, idx|
        validate_school(hand_school, shale.education[idx])
      end

      validate_address(hand.current_address, shale.current_address)

      valid?(hand.past_addresses.length, shale.past_addresses.length)
      hand.past_addresses.each_with_index do |hand_address, idx|
        validate_address(hand_address, shale.past_addresses[idx])
      end

      valid?(hand.contacts.length, shale.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, shale.contacts[idx])
      end

      validate_bank_account(hand.bank_acocunt, shale.bank_acocunt)
      validate_car(hand.current_car, shale.current_car)

      valid?(hand.cars.length, shale.cars.length)
      hand.cars.each_with_index do |hand_car, idx|
        validate_car(hand_car, shale.cars[idx])
      end

      validate_job(hand.current_job, shale.current_job)

      valid?(hand.jobs.length, shale.jobs.length)
      hand.jobs.each_with_index do |hand_job, idx|
        validate_job(hand_job, shale.jobs[idx])
      end

      valid?(hand.pets.length, shale.pets.length)
      hand.pets.each_with_index do |hand_pet, idx|
        validate_animal(hand_pet, shale.pets[idx])
      end

      valid?(hand.children.length, shale.children.length)
      hand.children.each_with_index do |hand_child, idx|
        validate_person(hand_child, shale.children[idx])
      end
    end

    def validate_animal(hand, shale)
      valid?(hand.kind, shale.kind)
      valid?(hand.breed, shale.breed)
      valid?(hand.name, shale.name)
    end

    def validate_job(hand, shale)
      valid?(hand.title, shale.title)
      valid?(hand.field, shale.field)
      valid?(hand.seniority, shale.seniority)
      valid?(hand.position, shale.position)
      valid?(hand.employment_type, shale.employment_type)
      validate_company(hand.company, shale.company)
    end

    def validate_car(hand, shale)
      valid?(hand.model, shale.model)
      valid?(hand.brand, shale.brand)
      validate_company(hand.manufacturer, shale.manufacturer)
    end

    def validate_bank_account(hand, shale)
      valid?(hand.number, shale.number)
      valid?(hand.balance, shale.balance)
      validate_company(hand.bank, shale.bank)
    end

    def validate_company(hand, shale)
      valid?(hand.name, shale.name)
      valid?(hand.industry, shale.industry)
      valid?(hand.ein, shale.ein)
      valid?(hand.type, shale.type)
      validate_address(hand.address, shale.address)

      valid?(hand.contacts.length, shale.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, shale.contacts[idx])
      end
    end

    def validate_school(hand, shale)
      valid?(hand.name, shale.name)
      validate_address(hand.address, shale.address)

      valid?(hand.contacts.length, shale.contacts.length)
      hand.contacts.each_with_index do |hand_contact, idx|
        validate_contact(hand_contact, shale.contacts[idx])
      end
    end

    def validate_contact(hand, shale)
      valid?(hand.type, shale.type)
      valid?(hand.contact, shale.contact)
    end

    def validate_address(hand, shale)
      valid?(hand.city, shale.city)
      valid?(hand.street, shale.street)
      valid?(hand.zip, shale.zip)
      valid?(hand.state, shale.state)
      valid?(hand.state_abbr, shale.state_abbr)
      valid?(hand.country, shale.country)
      valid?(hand.country_code, shale.country_code)
      valid?(hand.time_zone, shale.time_zone)
      valid?(hand.latitude, shale.latitude)
      valid?(hand.longitude, shale.longitude)
    end

    def valid?(a, b)
      raise "#{a} != #{b}" if a != b
    end
  end
end

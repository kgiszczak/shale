module ToHash
  class << self
    def build_address(model)
      {
        'city' => model.city,
        'street' =>  model.street,
        'zip' =>  model.zip,
        'state' =>  model.state,
        'state_abbr' =>  model.state_abbr,
        'country' =>  model.country,
        'country_code' =>  model.country_code,
        'time_zone' =>  model.time_zone,
        'latitude' =>  model.latitude,
        'longitude' =>  model.longitude,
      }
    end

    def build_contact(model)
      {
        'type' => model.type,
        'contact' => model.contact,
      }
    end

    def build_school(model)
      {
        'name' => model.name,
        'address' => build_address(model.address),
        'contacts' => model.contacts.map { |e| build_contact(e) },
      }
    end

    def build_company(model)
      {
        'name' => model.name,
        'industry' => model.industry,
        'ein' => model.ein,
        'type' => model.type,
        'address' => build_address(model.address),
        'contacts' => model.contacts.map { |e| build_contact(e) },
      }
    end

    def build_bank_account(model)
      {
        'number' => model.number,
        'balance' => model.balance,
        'bank' => build_company(model.bank),
      }
    end

    def build_car(model)
      {
        'model' => model.model,
        'brand' => model.brand,
        'manufacturer' => build_company(model.manufacturer),
      }
    end

    def build_job(model)
      {
        'title' => model.title,
        'field' => model.field,
        'seniority' => model.seniority,
        'position' => model.position,
        'employment_type' => model.employment_type,
        'company' => build_company(model.company),
      }
    end

    def build_animal(model)
      {
        'kind' => model.kind,
        'breed' => model.breed,
        'name' => model.name,
      }
    end

    def build_person(model)
      {
        'first_name' => model.first_name,
        'last_name' => model.last_name,
        'middle_name' => model.middle_name,
        'prefix' =>  model.prefix,
        'date_of_birth' => model.date_of_birth,
        'place_of_birth' => build_address(model.place_of_birth),
        'driving_license' =>  model.driving_license,
        'hobbies' => model.hobbies,
        'education' => model.education.map { |e| build_school(e) },
        'current_address' => build_address(model.current_address),
        'past_addresses' => model.past_addresses.map { |e| build_address(e) },
        'contacts' => model.contacts.map { |e| build_contact(e) },
        'bank_acocunt' => build_bank_account(model.bank_acocunt),
        'current_car' => build_car(model.current_car),
        'cars' => model.cars.map { |e| build_car(e) },
        'current_job' => build_job(model.current_job),
        'jobs' => model.jobs.map { |e| build_job(e) },
        'pets' => model.pets.map { |e| build_animal(e) },
        'children' => model.children.map { |e| build_person(e) },
      }
    end

    def build_report(model)
      {
        'people' => model.people.map { |e| build_person(e) }
      }
    end
  end
end

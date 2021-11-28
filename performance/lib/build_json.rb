require_relative 'data_model'

module BuildJson
  class << self
    def build_address(json)
      Address.new(
        city: json['city'],
        street:  json['street'],
        zip:  json['zip'],
        state:  json['state'],
        state_abbr:  json['state_abbr'],
        country:  json['country'],
        country_code:  json['country_code'],
        time_zone:  json['time_zone'],
        latitude:  json['latitude'],
        longitude:  json['longitude'],
      )
    end

    def build_contact(json)
      Contact.new(
        type: json['type'],
        contact: json['contact'],
      )
    end

    def build_school(json)
      School.new(
        name: json['name'],
        address: build_address(json['address']),
        contacts: json['contacts'].map { |e| build_contact(e) },
      )
    end

    def build_company(json)
      Company.new(
        name: json['name'],
        industry: json['industry'],
        ein: json['ein'],
        type: json['type'],
        address: build_address(json['address']),
        contacts: json['contacts'].map { |e| build_contact(e) },
      )
    end

    def build_bank_account(json)
      BankAccount.new(
        number: json['number'],
        balance: json['balance'],
        bank: build_company(json['bank']),
      )
    end

    def build_car(json)
      Car.new(
        model: json['model'],
        brand: json['brand'],
        manufacturer: build_company(json['manufacturer']),
      )
    end

    def build_job(json)
      Job.new(
        title: json['title'],
        field: json['field'],
        seniority: json['seniority'],
        position: json['position'],
        employment_type: json['employment_type'],
        company: build_company(json['company']),
      )
    end

    def build_animal(json)
      Animal.new(
        kind: json['kind'],
        breed: json['breed'],
        name: json['name'],
      )
    end

    def build_person(json)
      Person.new(
        first_name: json['first_name'],
        last_name: json['last_name'],
        middle_name: json['middle_name'],
        prefix:  json['prefix'],
        date_of_birth: json['date_of_birth'],
        place_of_birth: build_address(json['place_of_birth']),
        driving_license:  json['driving_license'],
        hobbies: json['hobbies'],
        education: json['education'].map { |e| build_school(e) },
        current_address: build_address(json['current_address']),
        past_addresses: json['past_addresses'].map { |e| build_address(e) },
        contacts: json['contacts'].map { |e| build_contact(e) },
        bank_acocunt: build_bank_account(json['bank_acocunt']),
        current_car: build_car(json['current_car']),
        cars: json['cars'].map { |e| build_car(e) },
        current_job: build_job(json['current_job']),
        jobs: json['jobs'].map { |e| build_job(e) },
        pets: json['pets'].map { |e| build_animal(e) },
        children: json['children'].map { |e| build_person(e) },
      )
    end

    def build_report(json)
      Report.new(
        people: json['people'].map { |e| build_person(e) }
      )
    end
  end
end

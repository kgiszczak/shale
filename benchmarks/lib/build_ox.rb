require_relative 'models'

module BuildOx
  class << self
    def build_address(xml)
      Address.new(
        city: xml.locate('city').first.text,
        street: xml.locate('street').first.text,
        zip: xml.locate('zip').first.text,
        state: xml.locate('state').first.text,
        state_abbr: xml.locate('state_abbr').first.text,
        country: xml.locate('country').first.text,
        country_code: xml.locate('country_code').first.text,
        time_zone: xml.locate('time_zone').first.text,
        latitude: xml.locate('latitude').first.text,
        longitude: xml.locate('longitude').first.text
      )
    end

    def build_contact(xml)
      Contact.new(
        type: xml.locate('type').first.text,
        contact: xml.locate('contact').first.text
      )
    end

    def build_school(xml)
      School.new(
        name: xml.locate('name').first.text,
        address: build_address(xml.locate('address').first),
        contacts: xml.locate('contact').map { |e| build_contact(e) }
      )
    end

    def build_company(xml)
      Company.new(
        name: xml.locate('name').first.text,
        industry: xml.locate('industry').first.text,
        ein: xml.locate('ein').first.text,
        type: xml.locate('type').first.text,
        address: build_address(xml.locate('address').first),
        contacts: xml.locate('contact').map { |e| build_contact(e) }
      )
    end

    def build_bank_account(xml)
      BankAccount.new(
        number: xml.locate('number').first.text,
        balance: xml.locate('balance').first.text,
        bank: build_company(xml.locate('bank').first)
      )
    end

    def build_car(xml)
      Car.new(
        model: xml.locate('model').first.text,
        brand: xml.locate('brand').first.text,
        manufacturer: build_company(xml.locate('manufacturer').first)
      )
    end

    def build_job(xml)
      Job.new(
        title: xml.locate('title').first.text,
        field: xml.locate('field').first.text,
        seniority: xml.locate('seniority').first.text,
        position: xml.locate('position').first.text,
        employment_type: xml.locate('employment_type').first.text,
        company: build_company(xml.locate('company').first)
      )
    end

    def build_animal(xml)
      Animal.new(
        kind: xml.locate('kind').first.text,
        breed: xml.locate('breed').first.text,
        name: xml.locate('name').first.text
      )
    end

    def build_person(xml)
      Person.new(
        first_name: xml.locate('first_name').first.text,
        last_name: xml.locate('last_name').first.text,
        middle_name: xml.locate('middle_name').first.text,
        prefix: xml.locate('prefix').first.text,
        date_of_birth: xml.locate('date_of_birth').first.text,
        place_of_birth: build_address(xml.locate('place_of_birth').first),
        driving_license: xml.locate('driving_license').first.text,
        hobbies: xml.locate('hobby').map(&:text),
        education: xml.locate('school').map { |e| build_school(e) },
        current_address: build_address(xml.locate('current_address').first),
        past_addresses: xml.locate('past_address').map { |e| build_address(e) },
        contacts: xml.locate('contact').map { |e| build_contact(e) },
        bank_acocunt: build_bank_account(xml.locate('bank_acocunt').first),
        current_car: build_car(xml.locate('current_car').first),
        cars: xml.locate('car').map { |e| build_car(e) },
        current_job: build_job(xml.locate('current_job').first),
        jobs: xml.locate('job').map { |e| build_job(e) },
        pets: xml.locate('pet').map { |e| build_animal(e) },
        children: xml.locate('child').map { |e| build_person(e) }
      )
    end

    def build_report(xml)
      Report.new(
        people: xml.locate('person').map { |e| build_person(e) }
      )
    end
  end
end

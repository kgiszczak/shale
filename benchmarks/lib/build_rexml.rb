require_relative 'models'

module BuildRexml
  class << self
    def build_address(xml)
      Address.new(
        city: xml.get_elements('city').first.text,
        street: xml.get_elements('street').first.text,
        zip: xml.get_elements('zip').first.text,
        state: xml.get_elements('state').first.text,
        state_abbr: xml.get_elements('state_abbr').first.text,
        country: xml.get_elements('country').first.text,
        country_code: xml.get_elements('country_code').first.text,
        time_zone: xml.get_elements('time_zone').first.text,
        latitude: xml.get_elements('latitude').first.text,
        longitude: xml.get_elements('longitude').first.text,
      )
    end

    def build_contact(xml)
      Contact.new(
        type: xml.get_elements('type').first.text,
        contact: xml.get_elements('contact').first.text,
      )
    end

    def build_school(xml)
      School.new(
        name: xml.get_elements('name').first.text,
        address: build_address(xml.get_elements('address').first),
        contacts: xml.get_elements('contact').map { |e| build_contact(e) },
      )
    end

    def build_company(xml)
      Company.new(
        name: xml.get_elements('name').first.text,
        industry: xml.get_elements('industry').first.text,
        ein: xml.get_elements('ein').first.text,
        type: xml.get_elements('type').first.text,
        address: build_address(xml.get_elements('address').first),
        contacts: xml.get_elements('contact').map { |e| build_contact(e) },
      )
    end

    def build_bank_account(xml)
      BankAccount.new(
        number: xml.get_elements('number').first.text,
        balance: xml.get_elements('balance').first.text,
        bank: build_company(xml.get_elements('bank').first),
      )
    end

    def build_car(xml)
      Car.new(
        model: xml.get_elements('model').first.text,
        brand: xml.get_elements('brand').first.text,
        manufacturer: build_company(xml.get_elements('manufacturer').first),
      )
    end

    def build_job(xml)
      Job.new(
        title: xml.get_elements('title').first.text,
        field: xml.get_elements('field').first.text,
        seniority: xml.get_elements('seniority').first.text,
        position: xml.get_elements('position').first.text,
        employment_type: xml.get_elements('employment_type').first.text,
        company: build_company(xml.get_elements('company').first),
      )
    end

    def build_animal(xml)
      Animal.new(
        kind: xml.get_elements('kind').first.text,
        breed: xml.get_elements('breed').first.text,
        name: xml.get_elements('name').first.text,
      )
    end

    def build_person(xml)
      Person.new(
        first_name: xml.get_elements('first_name').first.text,
        last_name: xml.get_elements('last_name').first.text,
        middle_name: xml.get_elements('middle_name').first.text,
        prefix:  xml.get_elements('prefix').first.text,
        date_of_birth: xml.get_elements('date_of_birth').first.text,
        place_of_birth: build_address(xml.get_elements('place_of_birth').first),
        driving_license:  xml.get_elements('driving_license').first.text,
        hobbies: xml.get_elements('hobby').map(&:text),
        education: xml.get_elements('school').map { |e| build_school(e) },
        current_address: build_address(xml.get_elements('current_address').first),
        past_addresses: xml.get_elements('past_address').map { |e| build_address(e) },
        contacts: xml.get_elements('contact').map { |e| build_contact(e) },
        bank_acocunt: build_bank_account(xml.get_elements('bank_acocunt').first),
        current_car: build_car(xml.get_elements('current_car').first),
        cars: xml.get_elements('car').map { |e| build_car(e) },
        current_job: build_job(xml.get_elements('current_job').first),
        jobs: xml.get_elements('job').map { |e| build_job(e) },
        pets: xml.get_elements('pet').map { |e| build_animal(e) },
        children: xml.get_elements('child').map { |e| build_person(e) },
      )
    end

    def build_report(xml)
      Report.new(
        people: xml.get_elements('//person').map { |e| build_person(e) }
      )
    end
  end
end

require_relative 'models'

module BuildNokogiriXpath
  class << self
    def build_address(xml)
      Address.new(
        city: xml.at_xpath('city').text,
        street: xml.at_xpath('street').text,
        zip: xml.at_xpath('zip').text,
        state: xml.at_xpath('state').text,
        state_abbr: xml.at_xpath('state_abbr').text,
        country: xml.at_xpath('country').text,
        country_code: xml.at_xpath('country_code').text,
        time_zone: xml.at_xpath('time_zone').text,
        latitude: xml.at_xpath('latitude').text,
        longitude: xml.at_xpath('longitude').text
      )
    end

    def build_contact(xml)
      Contact.new(
        type: xml.at_xpath('type').text,
        contact: xml.at_xpath('contact').text
      )
    end

    def build_school(xml)
      School.new(
        name: xml.at_xpath('name').text,
        address: build_address(xml.at_xpath('address')),
        contacts: xml.xpath('contact').map { |e| build_contact(e) }
      )
    end

    def build_company(xml)
      Company.new(
        name: xml.at_xpath('name').text,
        industry: xml.at_xpath('industry').text,
        ein: xml.at_xpath('ein').text,
        type: xml.at_xpath('type').text,
        address: build_address(xml.at_xpath('address')),
        contacts: xml.xpath('contact').map { |e| build_contact(e) }
      )
    end

    def build_bank_account(xml)
      BankAccount.new(
        number: xml.at_xpath('number').text,
        balance: xml.at_xpath('balance').text,
        bank: build_company(xml.at_xpath('bank'))
      )
    end

    def build_car(xml)
      Car.new(
        model: xml.at_xpath('model').text,
        brand: xml.at_xpath('brand').text,
        manufacturer: build_company(xml.at_xpath('manufacturer'))
      )
    end

    def build_job(xml)
      Job.new(
        title: xml.at_xpath('title').text,
        field: xml.at_xpath('field').text,
        seniority: xml.at_xpath('seniority').text,
        position: xml.at_xpath('position').text,
        employment_type: xml.at_xpath('employment_type').text,
        company: build_company(xml.at_xpath('company'))
      )
    end

    def build_animal(xml)
      Animal.new(
        kind: xml.at_xpath('kind').text,
        breed: xml.at_xpath('breed').text,
        name: xml.at_xpath('name').text
      )
    end

    def build_person(xml)
      Person.new(
        first_name: xml.at_xpath('first_name').text,
        last_name: xml.at_xpath('last_name').text,
        middle_name: xml.at_xpath('middle_name').text,
        prefix: xml.at_xpath('prefix').text,
        date_of_birth: xml.at_xpath('date_of_birth').text,
        place_of_birth: build_address(xml.at_xpath('place_of_birth')),
        driving_license: xml.at_xpath('driving_license').text,
        hobbies: xml.xpath('hobby').map(&:text),
        education: xml.xpath('school').map { |e| build_school(e) },
        current_address: build_address(xml.at_xpath('current_address')),
        past_addresses: xml.xpath('past_address').map { |e| build_address(e) },
        contacts: xml.xpath('contact').map { |e| build_contact(e) },
        bank_acocunt: build_bank_account(xml.at_xpath('bank_acocunt')),
        current_car: build_car(xml.at_xpath('current_car')),
        cars: xml.xpath('car').map { |e| build_car(e) },
        current_job: build_job(xml.at_xpath('current_job')),
        jobs: xml.xpath('job').map { |e| build_job(e) },
        pets: xml.xpath('pet').map { |e| build_animal(e) },
        children: xml.xpath('child').map { |e| build_person(e) }
      )
    end

    def build_report(xml)
      Report.new(
        people: xml.xpath('report/person').map { |e| build_person(e) }
      )
    end
  end
end

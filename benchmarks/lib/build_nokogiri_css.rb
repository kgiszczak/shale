require_relative 'models'

module BuildNokogiriCss
  class << self
    def build_address(xml)
      Address.new(
        city: xml.at_css('> city').text,
        street: xml.at_css('> street').text,
        zip: xml.at_css('> zip').text,
        state: xml.at_css('> state').text,
        state_abbr: xml.at_css('> state_abbr').text,
        country: xml.at_css('> country').text,
        country_code: xml.at_css('> country_code').text,
        time_zone: xml.at_css('> time_zone').text,
        latitude: xml.at_css('> latitude').text,
        longitude: xml.at_css('> longitude').text
      )
    end

    def build_contact(xml)
      Contact.new(
        type: xml.at_css('> type').text,
        contact: xml.at_css('> contact').text
      )
    end

    def build_school(xml)
      School.new(
        name: xml.at_css('> name').text,
        address: build_address(xml.at_css('> address')),
        contacts: xml.css('> contact').map { |e| build_contact(e) }
      )
    end

    def build_company(xml)
      Company.new(
        name: xml.at_css('> name').text,
        industry: xml.at_css('> industry').text,
        ein: xml.at_css('> ein').text,
        type: xml.at_css('> type').text,
        address: build_address(xml.at_css('> address')),
        contacts: xml.css('> contact').map { |e| build_contact(e) }
      )
    end

    def build_bank_account(xml)
      BankAccount.new(
        number: xml.at_css('> number').text,
        balance: xml.at_css('> balance').text,
        bank: build_company(xml.at_css('> bank'))
      )
    end

    def build_car(xml)
      Car.new(
        model: xml.at_css('model').text,
        brand: xml.at_css('brand').text,
        manufacturer: build_company(xml.at_css('manufacturer'))
      )
    end

    def build_job(xml)
      Job.new(
        title: xml.at_css('> title').text,
        field: xml.at_css('> field').text,
        seniority: xml.at_css('> seniority').text,
        position: xml.at_css('> position').text,
        employment_type: xml.at_css('> employment_type').text,
        company: build_company(xml.at_css('> company'))
      )
    end

    def build_animal(xml)
      Animal.new(
        kind: xml.at_css('> kind').text,
        breed: xml.at_css('> breed').text,
        name: xml.at_css('> name').text
      )
    end

    def build_person(xml)
      Person.new(
        first_name: xml.at_css('> first_name').text,
        last_name: xml.at_css('> last_name').text,
        middle_name: xml.at_css('> middle_name').text,
        prefix: xml.at_css('> prefix').text,
        date_of_birth: xml.at_css('> date_of_birth').text,
        place_of_birth: build_address(xml.at_css('> place_of_birth')),
        driving_license: xml.at_css('> driving_license').text,
        hobbies: xml.css('> hobby').map(&:text),
        education: xml.css('> school').map { |e| build_school(e) },
        current_address: build_address(xml.at_css('> current_address')),
        past_addresses: xml.css('> past_address').map { |e| build_address(e) },
        contacts: xml.css('> contact').map { |e| build_contact(e) },
        bank_acocunt: build_bank_account(xml.at_css('> bank_acocunt')),
        current_car: build_car(xml.at_css('> current_car')),
        cars: xml.css('> car').map { |e| build_car(e) },
        current_job: build_job(xml.at_css('> current_job')),
        jobs: xml.css('> job').map { |e| build_job(e) },
        pets: xml.css('> pet').map { |e| build_animal(e) },
        children: xml.css('> child').map { |e| build_person(e) }
      )
    end

    def build_report(xml)
      Report.new(
        people: xml.css('report person').map { |e| build_person(e) }
      )
    end
  end
end

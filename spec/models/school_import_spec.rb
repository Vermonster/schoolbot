require 'rails_helper'

describe SchoolImport do
  describe '.new' do
    it 'requires CSV data with name and address headers' do
      district = build(:district)
      invalid_data = [
        '',
        "foo,bar\nbaz,qux",
        "name,location\ntest name,test address",
        "school,address\ntest name,test address"
      ]

      invalid_data.each do |data|
        expect{
          SchoolImport.new(district: district, data: data)
        }.to raise_error ArgumentError
      end
    end
  end

  describe '#csv' do
    it 'allows access to the parsed CSV data after initialization' do
      import = SchoolImport.new(
        district: build(:district),
        data: "name,address,extra\ntest name,test address,extra data"
      )

      expect(import.csv.headers).to eq [:name, :address, :extra]
    end
  end

  describe '#import!' do
    it 'imports school data from a CSV file of names and addresses' do
      district = create(:district)
      data = %(Name,Address\n"School 1","Address 1"\n"School 2","Address 2")

      SchoolImport.new(district: district, data: data).import!

      schools = district.schools
      expect(schools.count).to be 2
      expect(schools.find_by(name: 'School 1').address).to eq 'Address 1'
      expect(schools.find_by(name: 'School 2').address).to eq 'Address 2'
    end

    it 'allows latitude and longitude to be provided instead of geocoding' do
      district = create(:district)
      data = "Name,Address,Latitude,Longitude\nSchool 3,Address 3,42.36,-71.03"

      SchoolImport.new(district: district, data: data).import!

      school = district.schools.first
      expect(school.latitude).to eq 42.36
      expect(school.longitude).to eq(-71.03)
    end

    it 'does not import anything if an error is encountered with a school' do
      district = create(:district)
      data = "name,address\nhas address,address1\nno address,"

      expect{
        SchoolImport.new(district: district, data: data).import!
      }.to raise_error ActiveModel::StrictValidationFailed

      expect(district.schools.count).to be 0
    end
  end
end

require 'csv'

class SchoolImport
  attr_reader :csv, :district

  def initialize(district:, data:)
    @district = district
    @csv = CSV.parse(data, headers: true, header_converters: [:symbol])

    if @csv.headers.blank? || (%i[name address] - @csv.headers).any?
      raise ArgumentError, 'CSV headers must include `name` and `address`!'
    end
  end

  def import!
    ActiveRecord::Base.transaction do
      @csv.each do |row|
        @district.schools.create!(row.to_h)
      end
    end
  end
end

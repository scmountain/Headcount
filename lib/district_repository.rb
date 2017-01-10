require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"
require_relative "../../headcount-master/lib/file_import"
require_relative "../../headcount-master/lib/clean_data"

require 'csv'

class DistrictRepository

  include FileImport
  include CleanData

  attr_reader :name,:districts, :enrollment_repository

  def initialize
    @districts = {}
    @enrollment_repository = EnrollmentRepository.new
  end

  def load_data(file)
    hidden_file = file[:enrollment][:kindergarten]
    contents = import_csv(hidden_file)
    contents.each do |row|
      district_name = clean_data(row[:location])
      @districts[district_name] = District.new({ name: district_name })
    end
    @enrollment_repository.load_data(file)
    assign_enrollments
  end


  def find_by_name(name_of_district)
    @districts[name_of_district]
  end

  def find_all_matching(search_criteria)
    @districts.find_all do |(key,value)|
      value.school_info[:name].include?(search_criteria)
    end.to_h.values
  end

  def find_enrollment(name)
    @enrollment_repository.find_by_name(name)
  end

  private

  def assign_enrollments
    @enrollment_repository.csv_data_clustered.each do |key, value|
      district = find_by_name(key.upcase)
      district.enrollment = value
    end
  end
end

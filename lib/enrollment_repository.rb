require "csv"

require_relative "district"
require_relative "enrollment"
require_relative "district_repository"
require_relative "file_import"
require_relative "clean_data"


class EnrollmentRepository
  include FileImport

  attr_reader :name, :enrollments
  attr_accessor :csv_data_clustered

  def initialize
    @csv_data_clustered = {}
  end

  def load_data(file)
    nested_symbols_to_call_data = file[:enrollment].keys
    nested_symbols_to_call_data.each do |key|
      hidden_files = file[:enrollment][key]
      contents = import_csv(hidden_files)
      contents.each do |row|
      name = row[:location].upcase
      year = row[:timeframe].to_i
      data = row[:data].to_f.round(3)
      make_enrollment(name, year, data, key)
    end
  end
    @csv_data_clustered
  end

  def make_enrollment(name, year, data, key)
    if key == :kindergarten
      if @csv_data_clustered.has_key?(name)
        @csv_data_clustered[name].kindergarten_participation[year] = data
      else
        e = Enrollment.new({:name => name,
                            :kindergarten_participation => {year => data},
                            :high_school_graduation => {}})
        @csv_data_clustered[name] = e
      end
    else
      @csv_data_clustered[name].high_school_graduation[year] = data
    end
  end

  def find_by_name(name)
    @csv_data_clustered[name]
  end
end

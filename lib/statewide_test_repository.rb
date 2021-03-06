require 'csv'
require_relative "statewide_test"
require_relative "file_import"
require_relative "clean_data"


class StatewideTestRepository

  include FileImport
  include CleanData

  def initialize
    @statewide_tests = {}
  end

  def load_data(file)

    file[:statewide_testing].each do |symbol, file_path|
      CSV.foreach file_path, headers: true, header_converters: :symbol do |row|
        name    = row[:location].upcase
        year    = row[:timeframe].to_i
        data = row[:data].to_f.round(3)
        race    = row[:race_ethnicity]
        score   = row[:score]

        if symbol == :third_grade || symbol == :eighth_grade
          if symbol == :third_grade
            top_level_key = 3
          elsif symbol == :eighth_grade
            top_level_key = 8
          end

          subject = score.downcase.to_sym
        else
          top_level_key = race.downcase.to_sym
          subject = symbol.downcase.to_sym
        end

        make_statewide_test(name, year, data, top_level_key, subject)
      end
    end
  end

  def make_statewide_test(name, year, data, top_level_key, subject)
    unless @statewide_tests.has_key?(name)
      @statewide_tests[name] = StatewideTest.new({
        :name => name,
        :grade_year_subject => {},
        :race_year_subject => {}
      })
    end

    statewide_test = @statewide_tests[name]
    if top_level_key == 3 || top_level_key == 8
      tlk = statewide_test.grade_year_subject
    else
      tlk = statewide_test.race_year_subject
    end

    tlk[top_level_key] = {} unless tlk.has_key?(top_level_key)
    tlk[top_level_key][year] = {} unless tlk[top_level_key].has_key?(year)
    tlk[top_level_key][year][subject] = data
  end

  def find_by_name(name)
    @statewide_tests[name.upcase]
  end
end

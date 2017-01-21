require 'csv'
require_relative "economic_profile"
require_relative "file_import"
require_relative "clean_data"

class EconomicProfileRepository

    include FileImport
    include CleanData

    attr_accessor :economic_profiles

  def initialize
    @economic_profiles = Hash.new(0)
  end

  def load_data(file)
    file[:economic_profile].each do |symbol, pathway|
        contents = import_csv(pathway)
        contents.each do |row|
      make_economic_profile(row, symbol)
    end
  end
end

  def make_economic_profile(row, symbol)
    if symbol == :median_household_income
      median_household_income_cruncher(row, symbol)
    elsif symbol == :children_in_poverty
      children_in_poverty_cruncher(row, symbol)
    elsif symbol == :free_or_reduced_price_lunch
      reduced_price_lunch_crunhcer(row, symbol)
    else
      symbol == :title_i
      # poverty_data(load_data(file), economic_type)
      # reduced_lunch_data(load_data(file), economic_type)
    end
  end

  def median_household_income_cruncher(row, symbol)
    year = year_formatting(row, symbol)
    data = row[:data].to_i
    name = row[:location]
    if @economic_profiles[name] != 0
      @economic_profiles[name].median_household_income[year] = data
    else
      ep = EconomicProfile.new({name: name, median_household_income: {year => data}})
      @economic_profiles[name] = ep
    end
  end

  def children_in_poverty_cruncher(row, symbol)
    year = row[:timeframe].to_i
    data = row[:data].to_f
    name = row[:location]
    if @economic_profiles[name].children_in_poverty == nil
      @economic_profiles[name].children_in_poverty = {year => data}
    else
      @economic_profiles[name].children_in_poverty[year] = data
    end
  end

  def reduced_price_lunch_crunhcer(row, symbol)
    poverty_check = row[:poverty_level]
    if poverty_check == "Eligible for Free or Reduced Lunch"
      year = row[:timeframe].to_i
      data = row[:data].to_f
      name = row[:location]
      percentage = row[:dataformat].to_sym
        if @economic_profiles[name].free_or_reduced_price_lunch == nil
          @economic_profiles[name].free_or_reduced_price_lunch = {year {{percent=> data}}
        else
          @economic_profiles[name].free_or_reduced_price_lunch[year] = data
      end
    end
  end

  def year_formatting(row, symbol)
    row[:timeframe].split("-").map {|a| a.to_i}
  end

  def determine_data_type(row)
    if row[:dataformat] == "Percent"
      :percentage
    else
      :total
    end
  end

  def determine_rate(row)
    format_number(row[:data])
  end

  def find_by_name(name)
    economic_profiles[name.upcase]
  end
end

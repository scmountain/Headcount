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
    require "pry"; binding.pry
  end
end

  def make_economic_profile(row, symbol)
    if symbol == :median_household_income
      year = year_formatting(row, symbol)
      data = row[:data].to_i
      name = row[:location]
      if @economic_profiles[name] != 0
        @economic_profiles[name].median_household_income[year] = data
      else
        ep = EconomicProfile.new({name: name, median_household_income: {year => data}})
        @economic_profiles[name] = ep
      end
    # elsif symbol == :children_in_poverty ||
    #
    #   symbol == :title_i
      # poverty_data(load_data(file), economic_type)
      # reduced_lunch_data(load_data(file), economic_type)
    end
  end

  def year_formatting(row, symbol)
    row[:timeframe].split("-").map {|a| a.to_i}
  end

  def income_data(economic_data, economic_type)
    economic_data.each do |row|
      district_name = row[:location]
      income        = row[:data].to_i
      years = row[:timeframe].split("-").map{ |num| num.to_i }
      row_data = { :name => district_name, economic_type =>
                    {years => income }}
        if !@economic_profiles[district_name]
          @economic_profiles[district_name] = EconomicProfile.new(row_data)
        else
          @economic_profiles[district_name].add_new_data(row_data)
        end
    end
  end

  def poverty_data(economic_data, economic_type)
    economic_data.each do |row|
      if row[:dataformat] == "Percent"
      district_name = row[:location]
      rate          = determine_rate(row)
      year          = row[:timeframe].to_i
      row_data      = { :name => district_name,
                        economic_type => {year => rate }}
        if !@economic_profiles[district_name]
          @economic_profiles[district_name] = EconomicProfile.new(row_data)
        else
          @economic_profiles[district_name].add_new_data(row_data)
        end
      end
    end
  end

  def reduced_lunch_data(economic_data, economic_type)
    economic_data.each do |row|
      if row[:poverty_level] == "Eligible for Free or Reduced Lunch"
      district_name = upcase_name(row[:location])
      year = row[:timeframe].to_i
      rate          = determine_rate(row)
      data_type = determine_data_type(row)
      row_data = { :name => district_name,
                    economic_type => {year => {data_type => rate } } }
        if !@economic_profiles[district_name]
          @economic_profiles[district_name] = EconomicProfile.new(row_data)
        else
          @economic_profiles[district_name].add_new_data(row_data)
        end
      end
    end
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

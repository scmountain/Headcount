require 'csv'

class EconomicProfile

  attr_accessor :name,
                  :median_household_income,
                  :children_in_poverty,
                  :title_i,
                  :free_or_reduced_price_lunch

    def initialize(data)
      @name = data[:name]
      @median_household_income = data[:median_household_income]
      @children_in_poverty     = data[:children_in_poverty]
      @free_or_reduced_price_lunch = data[:free_or_reduced_price_lunch]
      @title_i = data[:title_i]
    end

    def store_income_data(key, data)
      if median_household_income == nil
        @median_household_income = data
      else
        @median_household_income.merge!(data) do |years, original, addition|
          original.merge(addition)
      end
    end
    end

    def store_poverty_data(key, data)
      if children_in_poverty == nil
        @children_in_poverty = data
      else
        @children_in_poverty.merge!(data) do |year, original, addition|
          original.merge(addition)
        end
      end
    end

    def store_title_i_data(key, data)
      if title_i == nil
        @title_i = data
      else
        @title_i.merge!(data) do |year, original, addition|
          original.merge(addition)
        end
      end
    end

    def store_lunch_data(key, data)
      if free_or_reduced_price_lunch == nil
        @free_or_reduced_price_lunch = data
      else
        free_or_reduced_price_lunch.merge!(data) do |year, original, addition|
          original.merge(addition)
        end
      end
    end

    def median_household_income_in_year(year)
      average = []
      median_household_income.each_key do |key|
        if year.between?(key[0], key[1])
          average << median_household_income[key]
        end
      end
      average.reduce(:+) / average.count
      end

    def median_household_income_average
      average = median_household_income.values.reduce(:+)
      average / (median_household_income.values.count)
    end

    def children_in_poverty_in_year(year)
      raise UnknownDataError if children_in_poverty[year].nil?
      children_in_poverty[year]
    end

    def free_or_reduced_price_lunch_percentage_in_year(year)
      raise UnknownDataError if free_or_reduced_price_lunch[year].nil?
      format_number(free_or_reduced_price_lunch[year][:percentage])
    end

    def free_or_reduced_price_lunch_number_in_year(year)
      raise UnknownDataError if free_or_reduced_price_lunch[year].nil?
      free_or_reduced_price_lunch[year][:total]
    end

    def title_i_in_year(year)
      raise UnknownDataError if title_i[year].nil?
      title_i[year]
    end

  end

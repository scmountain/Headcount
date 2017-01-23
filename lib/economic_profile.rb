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


  def median_household_income_in_year(year)
    result = @median_household_income.keys.map do |range|
      full_range = (range[0]..range[1]).to_a
      @median_household_income[range] if full_range.include?(year)
    end
    numerator = result.compact.reduce(:+)
    result_length = result.compact.count
    numerator / result_length
  end

  def median_household_income_average
    result = @median_household_income.values.map do |value|
      value
    end
    numerator = result.compact.reduce(:+)
    result_length = result.compact.count
    numerator / result_length
  end

  def children_in_poverty_in_year(year)
    @children_in_poverty[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    @free_or_reduced_price_lunch[year][:percentage]
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    @free_or_reduced_price_lunch[year][:total]
  end

  def title_i_in_year(year)
    @title_i[year]
  end
end

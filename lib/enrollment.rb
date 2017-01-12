
require "csv"

require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"

class Enrollment

  attr_accessor :kindergarten, :name, :year, :high_school_graduation

  def initialize(input)
    @name = input[:name].upcase
    @kindergarten = input[:kindergarten_participation]
    @high_school_graduation = input[:high_school_graduation]
  end

  def kindergarten_participation_by_year
    @kindergarten
  end

  def kindergarten_participation_in_year(input)
    @kindergarten[input]
  end

  def graduation_rate_by_year
    @high_school_graduation
  end

  def graduation_rate_in_year(year)
    @high_school_graduation[year]
  end

end

require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"
require_relative "../../headcount-master/lib/file_import"
require_relative "../../headcount-master/lib/clean_data"

class HeadcountAnalyst
  attr_accessor :district_1, :district_2, :district_repository

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_1, district_2)
    get_district_data(district_1, district_2)
    dist_1_avg = find_the_average(@district_1.values)
    dist_2_avg = find_the_average(@district_2.values)
    find_the_variance(dist_1_avg,dist_2_avg)
  end

  def kindergarten_participation_rate_variation_trend(district_1, district_2)
    get_district_data(district_1, district_2)
    year_hash = {}
    years = @district_1.keys
    years.each do |year|
      if @district_2[year] > 0
        variance = find_the_variance(@district_1[year], @district_2[year])
        year_hash[year] = variance
      end
    end
    year_hash
  end

  def get_district_data(district_1, district_2)
    @district_1 = @district_repository.find_enrollment(district_1).kindergarten
    @district_2 = @district_repository.find_enrollment(district_2[:against]).kindergarten
  end

  def find_the_average(district_values)
    (district_values.reduce(:+) / district_values.count).round(3)
  end

  def find_the_variance(numerator, denominator)
    (numerator / denominator).round(3)
  end

  def kindergarten_participation_against_high_school_graduation(name)
    same_district_kindergarten_vs_highschool_maths(name)
  end

  def kindergarten_variation_district(name)
    statewide_average_kindergarten
    kindergarten_data = @district_repository.find_enrollment(name).kindergarten.values.reduce(:+)
    variation = (kindergarten_data / statewide_average_kindergarten)
  end

  def high_school_variation_district(name)
    statewide_average_high_school
    high_school_data = @district_repository.find_enrollment(name).high_school_graduation.values.reduce(:+)
    variation_hs = (high_school_data / statewide_average_high_school)
  end

  def statewide_average_high_school
    state_highschool_data = @district_repository.find_enrollment("Colorado").high_school_graduation
    state_highschool_data_maths = (state_highschool_data.values.reduce(:+) / state_highschool_data.count.to_f)
  end

  def statewide_average_kindergarten
    state_kindergarten_data = @district_repository.find_enrollment("Colorado").kindergarten
    kindergarten_data_maths = ( state_kindergarten_data.values.reduce(:+) / state_kindergarten_data.count )
  end

  def same_district_kindergarten_vs_highschool_maths(name)
    variation_totes = high_school_variation_district(name) / kindergarten_variation_district(name)
  end



end

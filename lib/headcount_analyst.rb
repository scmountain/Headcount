require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"
require_relative "../../headcount-master/lib/file_import"
require_relative "../../headcount-master/lib/clean_data"

class HeadcountAnalyst
  attr_accessor :district_1, :district_2, :district_repository, :statewide_answer, :makimultiple_districts_averages

  def initialize(district_repository)
    @district_repository = district_repository
    @state_name = "COLORADO"
    @statewide_answer
    @multiple_districts_averages = []
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
    kindergarten_data = (@district_repository.find_enrollment(name).kindergarten.values.reduce(:+) / @district_repository.find_enrollment(name).kindergarten.count)
    variation = (kindergarten_data / statewide_average_kindergarten)
  end

  def high_school_variation_district(name)
    denominator = @district_repository.find_enrollment(name).high_school_graduation.count
    numerator = @district_repository.find_enrollment(name).high_school_graduation.values.reduce(:+)
    numerator2 = find_the_variance(numerator, denominator)
    denominator2 = statewide_average_high_school
    find_the_variance(numerator2, denominator2)
  end

  def statewide_average_high_school
    state_highschool_data = @district_repository.find_enrollment(@state_name).high_school_graduation
    state_highschool_data_maths = (state_highschool_data.values.reduce(:+) / state_highschool_data.count.to_f)
  end

  def statewide_average_kindergarten
    state_kindergarten_data = @district_repository.find_enrollment(@state_name).kindergarten
    kindergarten_data_maths = ( state_kindergarten_data.values.reduce(:+) / state_kindergarten_data.count )
  end

  def same_district_kindergarten_vs_highschool_maths(name)
    numerator = kindergarten_variation_district(name)
    denominator = high_school_variation_district(name)
    find_the_variance(numerator, denominator)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    if name.keys ==[:across]
      name[:across].each do |district_name|
        percentage = kindergarten_participation_against_high_school_graduation(district_name)
        return false if percentage < 0.6 || percentage > 1.5
      end
      true
    elsif name.keys == [:for]
      if name[:for] == "STATEWIDE"
        statewide > 0.7
      end
    end
  end

  def statewide
    within_bounds = 0.0
    valid_districts_count = 0.0
    #if district vald AND is within bounds
      within_bounds += 1
      valid_districts += 1
    # else if district is valid, but not within bounds
      valid_districts += 1

    average within_bounds = within_bounds / valid_districts
    above_average = []
    below_average = []
    each_districts_average = @district_repository.districts.keys.map do |district_name|
      percentage = kindergarten_participation_against_high_school_graduation(district_name)
      if percentage > 0.6 && percentage < 1.5
        above_average << percentage
        above_average.count
      else
        below_average << percentage
        below_average.reject! &:nan?
        below_average.count
      end
    end
    numerator = above_average.count.to_f
    denominator = each_districts_average.count.to_f
    @statewide_answer = find_the_variance(numerator, denominator)
  end
end

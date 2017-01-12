require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"
require_relative "../../headcount-master/lib/file_import"
require_relative "../../headcount-master/lib/clean_data"

class HeadcountAnalyst
  attr_accessor :district_1,
                :district_2,
                :district_repository,
                :multiple_districts_averages,
                :state_name

  def initialize(district_repository)
    @district_repository = district_repository
    @state_name = "COLORADO"
    @multiple_districts_averages = []
  end

  def kindergarten_participation_rate_variation(d_1, d_2)
    get_district_data(d_1, d_2)
    dist_1_avg = find_the_average(@district_1.values)
    dist_2_avg = find_the_average(@district_2.values)
    find_the_variance(dist_1_avg,dist_2_avg)
  end

  def kindergarten_participation_rate_variation_trend(d_1, d_2)
    get_district_data(d_1, d_2)
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

  def get_district_data(d_1, d_2)
    @district_1 = @district_repository.find_enrollment(d_1)
    .kindergarten_participation
    @district_2 = @district_repository.find_enrollment(d_2[:against])
    .kindergarten_participation
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
    year_avg = @district_repository.find_enrollment(name)
    .kindergarten_participation.values
    kindergarten_data = (year_avg.reduce(:+) / year_avg.count)
    variation = (kindergarten_data / statewide_average_kindergarten)
  end

  def high_school_variation_district(name)
    year_avg = @district_repository.find_enrollment(name).high_school_graduation
    denominator = year_avg.count
    numerator = year_avg.values.reduce(:+)
    numerator2 = find_the_variance(numerator, denominator)
    denominator2 = statewide_average_high_school
    find_the_variance(numerator2, denominator2)
  end

  def statewide_average_high_school
    enrollment_data = @district_repository.find_enrollment(@state_name)
    co_hs_data = enrollment_data.high_school_graduation
    state_hs_data_maths = (co_hs_data.values.reduce(:+) / co_hs_data.count.to_f)
  end

  def statewide_average_kindergarten
    co_kg_data = @district_repository.find_enrollment(@state_name)
    .kindergarten_participation
    kindergarten_data_maths = (co_kg_data.values.reduce(:+) / co_kg_data.count)
  end

  def same_district_kindergarten_vs_highschool_maths(name)
    numerator = kindergarten_variation_district(name)
    denominator = high_school_variation_district(name)
    find_the_variance(numerator, denominator)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(name)
    if name.keys ==[:across]
      name[:across].each do |dn|
        p = kindergarten_participation_against_high_school_graduation(dn)
        return false if p < 0.6 || p > 1.5
      end
      true
    else
      statewide_data_window(name)
    end
  end

  def statewide_data_window(name)
    if name[:for] != "STATEWIDE"
      dn = name[:for]
      percentage = kindergarten_participation_against_high_school_graduation(dn)
      return false if percentage < 0.6 || percentage > 1.5
      true
    else
      statewide > 0.7
    end
  end

  def statewide
    above_average = []
    below_average = []
    e = @district_repository.districts.keys.map do |dn|
      percentage = kindergarten_participation_against_high_school_graduation(dn)
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
    denominator = e.count.to_f
    statewide_answer = find_the_variance(numerator, denominator)
  end
end

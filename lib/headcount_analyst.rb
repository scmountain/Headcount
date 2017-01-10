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

end

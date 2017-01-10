require './test/test_helper'
require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"
require_relative "../../headcount-master/lib/headcount_analyst"


class HeadcountAnalystTest < MiniTest::Test


  def test_district_1_manipulation

  end


  def test_variables

    ha = HeadcountAnalyst.new("jaeger")
    assert_equal "jaeger", ha.district_repository
  end

  def test_enrollment_analysis_basics

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_in_delta 1.126, ha.kindergarten_participation_rate_variation("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1"), 0.005
    assert_in_delta 0.447, ha.kindergarten_participation_rate_variation('ACADEMY 20', :against => 'YUMA SCHOOL DISTRICT 1'), 0.005
  end

  def test_get_district_info

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    info = ha.get_district_data("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    assert_equal 1.0, info[2009]
  end

  def test_find_the_average

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    values = [0.129, 0.135, 0.15]
    info = ha.find_the_average(values)
    assert_equal 0.138, info
  end

  def test_it_can_find_the_variance_between_two_districts

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    assert_equal 1.124, ha.find_the_variance(0.426, 0.379)
  end

  def test_kindergarten_participation_rate_varitation_tend

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
  end

  def test_kindergarten_participation_rate_varitation_tend

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    ha = HeadcountAnalyst.new(dr)
    ha.kindergarten_participation_rate_variation_trend("GUNNISON WATERSHED RE1J", :against => "TELLURIDE R-1")
    district_1 = "GUNNISON WATERSHED RE1J"
    district_2 = {:against=>"TELLURIDE R-1"}
    answer = {2009=>0.68, 2010=>0.662, 2011=>0.626, 2012=>0.708, 2014=>5.006}

    assert_equal answer, ha.kindergarten_participation_rate_variation_trend(district_1, district_2)
  end

  def test_high_school_versus_kindergarten_analysis

    dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
      :high_school_graduation => "./data/High school graduation rates.csv"}})
      ha = HeadcountAnalyst.new(dr)

      assert_equal 0.548, ha.kindergarten_participation_against_high_school_graduation('MONTROSE COUNTY RE-1J'), 0.005
      assert_in_delta 0.800, ha.kindergarten_participation_against_high_school_graduation('STEAMBOAT SPRINGS RE-2'), 0.005
    end

    def test_does_kindergarten_participation_predict_hs_graduation
      skip
      dr = DistrictRepository.new
      dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"}})
        ha = HeadcountAnalyst.new(dr)

        assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'ACADEMY 20')
        refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'MONTROSE COUNTY RE-1J')
        refute ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'SIERRA GRANDE R-30')
        assert ha.kindergarten_participation_correlates_with_high_school_graduation(for: 'PARK (ESTES PARK) R-3')
      end

      def test_statewide_kindergarten_high_school_prediction
        skip
        dr = DistrictRepository.new
        dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
          :high_school_graduation => "./data/High school graduation rates.csv"}})
          ha = HeadcountAnalyst.new(dr)

          refute ha.kindergarten_participation_correlates_with_high_school_graduation(:for => 'STATEWIDE')
        end

        def test_kindergarten_hs_prediction_multi_district
          skip
          dr = DistrictRepository.new
          dr.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv",
            :high_school_graduation => "./data/High school graduation rates.csv"}})
            ha = HeadcountAnalyst.new(dr)
            districts = ["ACADEMY 20", 'PARK (ESTES PARK) R-3', 'YUMA SCHOOL DISTRICT 1']
            assert ha.kindergarten_participation_correlates_with_high_school_graduation(:across => districts)
          end

end

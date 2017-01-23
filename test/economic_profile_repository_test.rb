require "./test/test_helper"
require_relative "../lib/economic_profile_repository"
require_relative "../lib/economic_profile"


class EconomicProgileRepositoryTest < MiniTest::Test

  def data
    {
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    }
  end

  def test_new_hash_is_created
    epr = EconomicProfileRepository.new
    assert Hash, epr.economic_profiles
  end

  def test_brings_in_a_name
    epr = EconomicProfileRepository.new
    epr.load_data(data)
    ep = epr.find_by_name("ACADEMY 20")
    assert_instance_of EconomicProfile, ep
    assert_equal "ACADEMY 20", ep.name
  end

  def test

  end
end

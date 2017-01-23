require "./test/test_helper"
require_relative "../lib/economic_profile"

class EconomicProfileTest < MiniTest::Test

  def data
    {
    name: "name",
    median_household_income: {[2006, 2010]=>85450, [2008, 2012]=>89615, [2007, 2011]=>88099, [2009, 2013]=>89953},
    children_in_poverty:
      {
        1995=>0.032,
        1997=>0.035,
        1999=>0.032,
        2000=>0.031
      },
    free_or_reduced_price_lunch:
    {
      2014=>{:total=>3132, :percentage=>0.127},
      2004=>{:total=>1182, :percentage=>0.06},
      2003=>{:percentage=>0.06, :total=>1062},
      2002=>{:total=>905, :percentage=>0.048},
      2001=>{:percentage=>0.047, :total=>855},
      2000=>{:total=>701, :percentage=>0.04}
     },
    title_i: {2009=>0.014, 2011=>0.011, 2012=>0.0107, 2013=>0.0125, 2014=>0.027}
  }
  end

  def test_variable_creation
    ep = EconomicProfile.new(data)
    expected_income = {[2006, 2010]=>85450, [2008, 2012]=>89615, [2007, 2011]=>88099, [2009, 2013]=>89953}
    expected_lunch = {2014=>{:total=>3132, :percentage=>0.127},
   2004=>{:total=>1182, :percentage=>0.06},
   2003=>{:percentage=>0.06, :total=>1062},
   2002=>{:total=>905, :percentage=>0.048},
   2001=>{:percentage=>0.047, :total=>855},
   2000=>{:total=>701, :percentage=>0.04}}
   expected_title_i = {2009=>0.014, 2011=>0.011, 2012=>0.0107, 2013=>0.0125, 2014=>0.027}
   expected_poverty = {1995=>0.032, 1997=>0.035, 1999=>0.032, 2000=>0.031}
    assert_equal "name", ep.name
    assert_equal expected_income, ep.median_household_income
    assert_equal expected_lunch, ep.free_or_reduced_price_lunch
    assert_equal expected_title_i, ep.title_i
    assert_equal expected_poverty, ep.children_in_poverty
  end

  def test_median_household_year
    ep = EconomicProfile.new(data)
    assert_equal 85450, ep.median_household_income_in_year(2006)
  end

  def test_median_household_avg
    ep = EconomicProfile.new(data)
    assert_equal 88279, ep.median_household_income_average
  end

  def test_children_in_poverty
    ep = EconomicProfile.new(data)
    assert_equal 0.031, ep.children_in_poverty_in_year(2000)
  end

  def test_lunch_year
    ep = EconomicProfile.new(data)
    assert_equal 3132, ep.free_or_reduced_price_lunch_number_in_year(2014)
  end

  def test_lunch_percentage
    ep = EconomicProfile.new(data)
    assert_equal 0.127, ep.free_or_reduced_price_lunch_percentage_in_year(2014)
  end

  def test_title_i_in_year
    ep = EconomicProfile.new(data)
    assert_equal 0.014, ep.title_i_in_year(2009)
  end

  def test_ep_key
    data = {:median_household_income => {[2005, 2009] => 50000, [2008, 2014] => 60000},
        :children_in_poverty => {2012 => 0.1845},
        :free_or_reduced_price_lunch => {2014 => {:percentage => 0.023, :total => 100}},
        :title_i => {2015 => 0.543},
        :name => "ACADEMY 20"
       }
       economic_profile = EconomicProfile.new(data)
  end
end

require "./test/test_helper"
require_relative "../lib/economic_profile"

class EconomicProfileTest < MiniTest::Test

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

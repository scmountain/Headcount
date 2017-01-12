require "csv"

require_relative "district_repository"
require_relative "enrollment"
require_relative "enrollment_repository"

class District
  attr_reader :school_info
  attr_accessor :enrollment

  def initialize(school_info)
    @school_info = school_info
    @enrollment = nil
    @statewide_test
  end

  def statewide_test
    StatewideTest.new
  end

  def name
    @school_info.values.first
  end
end

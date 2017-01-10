require "csv"

require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"

class District
  attr_reader :school_info
  attr_accessor :enrollment

  def initialize(school_info)
    @school_info = school_info
    @enrollment = nil
  end

  def name
    @school_info.values.first
  end
end

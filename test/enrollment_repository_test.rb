require './test/test_helper'
require_relative "../../headcount-master/lib/district_repository"
require_relative "../../headcount-master/lib/district"
require_relative "../../headcount-master/lib/enrollment"
require_relative "../../headcount-master/lib/enrollment_repository"

class EnrollmentRepositoryTest < MiniTest::Test

  def test_variable_creation
    er = EnrollmentRepository.new
    assert_equal er.csv_data_clustered, {}
  end

  def test_load_data_has_nested_files
    er = EnrollmentRepository.new
    csv_file = {:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}}
    assert_equal Hash, er.load_data(csv_file).class
  end

  def test_make_enrollment
    er = EnrollmentRepository.new
    enrollment = er.make_enrollment("Turing" , 2007, 0.34, :kindergarten)
    assert_equal "Turing", enrollment.name
    assert_equal [2007], enrollment.kindergarten.keys
    assert_equal [0.34], enrollment.kindergarten.values
  end

  def test_enrollment_formatting
    er = EnrollmentRepository.new
    enrollment = er.make_enrollment("Turing" , 2007, 0.34, :kindergarten)
    assert_equal Hash, enrollment.kindergarten.class
  end

  def test_load_data_has_nested_files
    er = EnrollmentRepository.new
    csv_file = {:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}}
    enrollment = er.load_data(csv_file)
    assert_instance_of Hash, er.load_data(csv_file)
    refute_empty enrollment
  end

  def test_find_by_name
    er = EnrollmentRepository.new
    er.load_data({
               :enrollment => {
                 :kindergarten => "./data/Kindergartners in full-day program.csv",
                 :high_school_graduation => "./data/High school graduation rates.csv"
               }
             })

    er.load_data({:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}})
    name = "WELD COUNTY RE-1"
    enrollment = er.find_by_name(name)
    assert_equal name, enrollment.name
  end


  def test_loading_and_finding_enrollments
    er = EnrollmentRepository.new
    er.load_data({
               :enrollment => {
                 :kindergarten => "./data/Kindergartners in full-day program.csv",
                 :high_school_graduation => "./data/High school graduation rates.csv"
               }
             })

    name = "GUNNISON WATERSHED RE1J"
    enrollment = er.find_by_name(name)
    assert_equal name, enrollment.name
    assert enrollment.is_a?(Enrollment)
    assert_in_delta 0.144, enrollment.kindergarten_participation_in_year(2004), 0.005
  end

  #########ITERATION 2###############
  def test_enrollment_repository_with_high_school_data
    er = EnrollmentRepository.new
    er.load_data({
               :enrollment => {
                 :kindergarten => "./data/Kindergartners in full-day program.csv",
                 :high_school_graduation => "./data/High school graduation rates.csv"
               }
             })
      e = er.find_by_name("MONTROSE COUNTY RE-1J")
      expected = {2010=>0.738, 2011=>0.751, 2012=>0.777, 2013=>0.713, 2014=>0.757}
      expected.each do |k,v|
        assert_in_delta v, e.graduation_rate_by_year[k], 0.005
      end
      assert_in_delta 0.738, e.graduation_rate_in_year(2010), 0.005
    end
  end

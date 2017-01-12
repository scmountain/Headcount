require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

  def test_statewide_test_repo_exists
    statewide = StatewideTestRepository.new
    assert_instance_of StatewideTestRepository, statewide
  end

  def test_statewide_test_repo_find_name
    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    academy_20_statewide_test = statewide_repo.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", academy_20_statewide_test.name
  end

  def test_statewide_test_repo_proficient_by_grade
    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    academy_20_statewide_test = statewide_repo.find_by_name("ACADEMY 20")
    year_hash = academy_20_statewide_test.proficient_by_grade(8)

    assert_equal 7, year_hash.keys.length
    assert_equal true, year_hash.has_key?(2008)

    subject_hash = year_hash[2008]
    assert_equal 3, subject_hash.keys.length
    assert_equal true, subject_hash.has_key?(:math)
    assert_equal true, subject_hash.has_key?(:reading)
    assert_equal true, subject_hash.has_key?(:writing)
    assert_equal 0.64, subject_hash[:math]
    assert_equal 0.843, subject_hash[:reading]
    assert_equal 0.734, subject_hash[:writing]
  end

  def test_statewide_test_repo_proficient_by_race
  statewide_repo = StatewideTestRepository.new
  statewide_repo.load_data({
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })

  academy_20_statewide_test = statewide_repo.find_by_name("ACADEMY 20")
  year_hash = academy_20_statewide_test.proficient_by_race_or_ethnicity(:asian)

  assert_equal 4, year_hash.keys.length
  assert_equal true, year_hash.has_key?(2011)

  subject_hash = year_hash[2011]
  assert_equal 3, subject_hash.keys.length
  assert_equal true, subject_hash.has_key?(:math)
  assert_equal true, subject_hash.has_key?(:reading)
  assert_equal true, subject_hash.has_key?(:writing)
  assert_equal 0.817, subject_hash[:math]
  assert_equal 0.898, subject_hash[:reading]
  assert_equal 0.827, subject_hash[:writing]
  end

  def test_statewide_test_repo_proficient_for_subject_by_grade_in_year

  statewide_repo = StatewideTestRepository.new
  statewide_repo.load_data({
    :statewide_testing => {
      :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
      :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
      :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
      :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
      :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    }
  })

  academy_20_statewide_test = statewide_repo.find_by_name("ACADEMY 20")
  proficiency = academy_20_statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2009)

  assert_equal 0.824, proficiency
  end

  def test_statewide_test_repo_proficient_for_subject_by_race_in_year

    statewide_repo = StatewideTestRepository.new
    statewide_repo.load_data({
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })

    academy_20_statewide_test = statewide_repo.find_by_name("ACADEMY 20")
    proficiency = academy_20_statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2011)

    assert_equal 0.817, proficiency
  end

end

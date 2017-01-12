require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_statewide_test_exists
    statewide_test = StatewideTest.new()

    assert_instance_of StatewideTest, statewide_test
  end

  def test_statewide_test_has_name
    statewide_test = StatewideTest.new({:name => "COLORADO"})

    assert_equal "COLORADO", statewide_test.name
  end

  def test_statewide_test_has_grades
    statewide_test = StatewideTest.new({
      :name => "COLORADO",
      :grade_year_subject => {
        3 => {
          2008 => {
            :math => 0.64,
            :reading => 0.843,
            :writing => 0.734
          }
        }
      }
    })

    year_hash = statewide_test.proficient_by_grade(3)

    assert_equal 1, year_hash.keys.length
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

  def test_statewide_test_has_grades
    statewide_test = StatewideTest.new({
      :name => "COLORADO",
      :race_year_subject => {
        :asian => {
          2008 => {
            :math => 0.64,
            :reading => 0.843,
            :writing => 0.734
          }
        }
      }
    })

    year_hash = statewide_test.proficient_by_race_or_ethnicity(:asian)

    assert_equal 1, year_hash.keys.length
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

  def test_statewide_test_proficient_for_subject_by_grade_in_year
    statewide_test = StatewideTest.new({
      :name => "COLORADO",
      :grade_year_subject => {
        3 => {
          2008 => {
            :math => 0.64,
            :reading => 0.843,
            :writing => 0.734
          }
        }
      }
    })

    assert_equal 0.64, statewide_test.proficient_for_subject_by_grade_in_year(:math, 3, 2008)
  end


  def test_statewide_test_proficient_for_subject_by_race_in_year
    statewide_test = StatewideTest.new({
      :name => "COLORADO",
      :race_year_subject => {
        :asian => {
          2008 => {
            :math => 0.64,
            :reading => 0.843,
            :writing => 0.734
          }
        }
      }
    })

    assert_equal 0.64, statewide_test.proficient_for_subject_by_race_in_year(:math, :asian, 2008)
  end
end

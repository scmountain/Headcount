class StatewideTest
  attr_reader :name, :grade_year_subject, :race_year_subject

  def initialize(input = {})
    @name = input[:name]
    @grade_year_subject = input[:grade_year_subject] if input
    .has_key?(:grade_year_subject)
    @race_year_subject = input[:race_year_subject] if input
    .has_key?(:race_year_subject)
  end

  def proficient_by_grade(grade)
    @grade_year_subject[grade]
  end

  def proficient_by_race_or_ethnicity(race)
    @race_year_subject[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    @grade_year_subject[grade][year][subject]
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    @race_year_subject[race][year][subject]
  end
end

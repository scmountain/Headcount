require_relative './file_import'


module CleanData

  def clean_data(input)
    input.upcase
  end


  def test_creates_three_decimals
    to_s[0..4].to_f
  end
  # def load_data(file)
  #   hidden_files = file[:enrollment][:kindergarten]
  #   contents = import_csv(hidden_files)
  #   contents.each do |row|
  #     name = row[:location]
  #     year = row[:timeframe].to_i
  #     data = row[:data].to_f.round(3)
  #     make_enrollment(name, year, data)
  #   end
end

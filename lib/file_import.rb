require 'csv'

module FileImport

  def import_csv(file_thing)
   CSV.open file_thing, headers: true, header_converters: :symbol
  end

end

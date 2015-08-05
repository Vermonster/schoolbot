module ZonarStubbing
  CSV_PATH = 'spec/support/files/zonar_showposition_path-brockton.csv'

  def zonar_csv_headers
    @zonar_csv_headers ||= File.readlines(CSV_PATH).first
  end

  def zonar_csv
    @zonar_csv ||= File.read(CSV_PATH)
  end

  def zonar_csv_rows
    @zonar_csv_rows ||= CSV.parse(zonar_csv, headers: true)
  end

  def stub_zonar(response = zonar_csv)
    stub_request(:get, /.*.zonarsystems.net/).to_return body: response
  end
end

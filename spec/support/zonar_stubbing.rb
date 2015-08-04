module ZonarStubbing
  def zonar_csv
    @zonar_csv ||= File.read('spec/support/files/zonar_showposition_path-brockton.csv')
  end

  def zonar_csv_rows
    @zonar_csv_rows ||= CSV.parse(zonar_csv, headers: true)
  end

  def stub_zonar
    stub_request(:get, /.*.zonarsystems.net/).to_return body: zonar_csv
  end
end

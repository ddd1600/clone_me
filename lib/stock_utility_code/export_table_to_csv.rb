require 'csv'

class ExportTableToCsv
  def self.go(classy, ar_ary=nil)
    tags = [classy.column_names.map(&:titleize)]
    records =  ar_ary || classy.all
    data = records.map(&:attributes).map(&:to_a).map { |m| m.inject([]) { |data, pair| data << pair.last } }
    rows = tags + data
    File.open("#{classy.to_s}_csv_dump.csv", "w") {|f| f.write(@rows.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}
  end
end

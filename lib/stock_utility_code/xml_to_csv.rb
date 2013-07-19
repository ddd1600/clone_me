	$:.unshift File.dirname(__FILE__)
	require 'open-uri'
	require 'nokogiri'
	require 'csv'

class XmlToCsv
 
   attr_reader :csvlines

    def initialize
	#f = File.open(ARGV[0]).read
	f = File.open("portfolio.xml")
	@doc = Nokogiri::XML(f)
	@positions = @doc.xpath("//OpenPosition")
	@csvlines = []
	headers = @positions.first.to_a.map(&:first)
	@csvlines << headers
	@positions.shift
    end

    def get_csv
	@positions.each do |row_groups|
	  csvline = []
	  row_groups.each do |pair|
	    csvline << pair.last
	  end
	  @csvlines << csvline  
	end
	@csvlines
        File.open("portfolio.csv", "w") do |f| 
	    f.write(csvlines.inject([]) do |csv, row|
	      	csv << CSV.generate_line(row) 
	    end.join(""))
	end
  end
end

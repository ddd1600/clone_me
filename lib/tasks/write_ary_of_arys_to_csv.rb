require 'csv'

class WriteAryOfArysToCsv
  
  def self.go(fn, ary_of_arys)
    fn = "#{Dir.pwd}/#{fn}"
    CSV.open(fn, 'w') do |csv|
      ary_of_arys.each do |ary|
        csv << ary
      end# of arys
    end# of csv
  end# of go
  
end# of class
require 'csv'

class DeviationFromTrendline
  
  attr_reader :records, :symbols, :distances, :sdvars, :csv, :rows, :points, :arys
  
  def initialize
    @records = Yearly.where(:year => 2012)
    @symbols = @records.map(&:symbol)
    @cols = ["Symbol", "Return on Equity (%)", "PB Ratio", "Standard Deviations from Trendline"]
    @y_fx = lambda { |m, x, b| ((m * x) + b) }
    @regr_formula = MathHelper.get_linear_regression_values(@records, "return_on_equity_pctg", "pb_ratio")
    m = regr_formula.first
    b  = regr_formula.last
    @x1 = -10000
    @x2 = 10000
    @y1 = (m * @x1) + b
    @y2 = (m * @x2) + b
  end
  
  def go
    @points =  @records.map { |y| [y.return_on_equity_pctg, y.pb_ratio] }
    @distances = MathHelper.get_distances_from_trendline("return_on_equity_pctg", "pb_ratio", @records)
    @sdvars = MathHelper.get_stdeviations(distances)
    5/0 unless @symbols.count == @records.count
    5/0 unless @sdvars.count == @distances.count
    5/0 unless @symbols.count == @distances.count
    @arys = []
    @symbols.each_with_index do |symbol, i|
      next unless @points[i][0]
      next unless @points[i][1]
      next unless @sdvars[i]
      ary = []
      ary << symbol
      x3 = @points[i][0]
      y3 = @points[i][1]
      ary << x3
      ary << y3
      ary << (determine_pos_or_neg(x3, y3) * @sdvars[i])
      @arys << ary
    end
    @csv = []
    @csv << [CSV.generate_line(@cols)]
    @rows = arys
    arys.each do |row|
      puts row
      @csv << [CSV.generate_line(row)]
    end
    @csv = @csv.join("")
    puts @csv
    File.open("trendline_deviation_stats.csv", "w") { |f| f.write(csv) }
  end
  
  def determine_pos_or_neg(x3, y3)
    det = Matrix[
      [(@x2-@x1), (x3-@x1)],
      [(@y2-@y1), (y3-@y1)]
    ].determinant
    if det > 0
      1
    elsif det < 0
      -1
    elsif det == 0
      0
    end
  end
  
end

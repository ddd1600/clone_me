class BetterChartHelper
  
  def construct_series()
  end
  
  def self.generic(chartname, hsh)
    chart = LazyHighCharts::HighChart.new(chartname) do |f|
      f.options[:chart][:defaultSeriesType] = hsh[:defaultSeriesType]
      f.options[:chart][:height] = (hsh[:series].count * hsh[:y]) if hsh[:y]
      f.options[:xAxis][:categories] = hsh[:x_categories]
      f.options[:yAxis][:opposite] = hsh[:yaxis_on_right] #if no match defaults to false
      f.legend(hsh[:legend_hsh]) if hsh[:legend_hsh]
      f.plot_options(hsh[:plot_options_hsh]) if hsh[:plot_options_hsh]
      hsh[:series].each do |series_hsh|
        f.series(series_hsh)    #ex: { :name => "Dogs", :data => [1, 2, 3] }
      end
    end
    chart
  end
  
end

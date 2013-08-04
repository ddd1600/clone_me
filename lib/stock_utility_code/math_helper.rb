class MathHelper
  
  def self.get_stdeviations(distances)
    sd = distances.compact.standard_deviation
    sdvars = []
    distances.each do |distance|
      if distance == nil
        sdvars << nil
      else
      sdvar = (distance / sd)
      sdvars << sdvar
      end
    end
    sdvars
  end
  
  def self.get_distances_from_trendline(xcol, ycol, ar_ary) #also generates the trendline
    points = ar_ary.map { |r| [r[xcol.to_sym], r[ycol.to_sym]] }
    regression_formula = MathHelper.get_linear_regression_values(ar_ary, xcol, ycol)
    m = regression_formula.first
    b = regression_formula.last
    distances = []
    points.each_with_index do |pair, i|
      x = pair.first
      y = pair.last
      if x == nil
        distances << nil
      elsif y == nil
        distances << nil
      else
      distances << ((y - m * x - b).abs / Math.sqrt(m**2 + 1))
      end
    end
    distances
  end
  
  def self.get_linear_regression_values(ar_ary, xcol, ycol)
    xs = ar_ary.map(&xcol.to_sym)
    ys = ar_ary.map(&ycol.to_sym)
    xv = xs.to_vector(:scale); yv = ys.to_vector(:scale)
    ds = { "x" => xv, "y" => yv }.to_dataset
    mlr = Statsample::Regression.multiple(ds, 'y')
    y_int = mlr.constant
    slope = mlr.coeffs['x']
    [slope, y_int]
  end
  
  def self.round_off_ar_ary_records_to(round_to, classy, column_name_string)
    classy.where("#{column_name_string} IS NOT NULL").each do |a|
      a[column_name_string.to_sym] = a[column_name_string.to_sym].round(round_to)
      a.save
    end
  end
  
  
  
  def self.get_linear_regr_slope(ar_ary, column_name)
    column_name = column_name.to_sym
    begin
    xs = ar_ary.map(&:year)
    ys = ar_ary.map(&column_name)
    xv = xs.to_vector(:scale); yv = ys.to_vector(:scale)
    ds = { "x" => xv, "y" => yv }.to_dataset
    mlr = Statsample::Regression.multiple(ds, 'y')
    y_int = mlr.constant
    slope = mlr.coeffs['x']
    slope
    rescue TypeError
      return nil
    end
  end
  
  def self.sum(ary)
    number = 0
    ary.each do |t|
      next if t.nil?
      number += t
    end
    number.to_f
  end
  
  def self.average(ary)
    sum = MathHelper.sum(ary)
    x = sum / ary.count.to_f
    x.round(2)
  end
  
  def self.min_max_for_x_y(ar_ary, y_sym, x_sym)
    hsh = {}
    ys = ar_ary.map(&y_sym.to_sym)
    xs = ar_ary.map(&x_sym.to_sym)
    hsh[:y_min] = ys.min
    hsh[:x_min] = xs.min
    hsh[:y_max] = ys.max
    hsh[:y_min] = ys.min
    hsh
  end
  
end

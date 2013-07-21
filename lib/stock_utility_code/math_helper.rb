class MathHelper
  
  def self.get_distances_from_trendline(xcol, ycol, ar_ary) #also generates the trendline
    points = ar_ary.map { |r| [r[xcol.to_sym], r[ycol.to_sym]] }
    regression_formula = MathHelper.get_linear_regression_values(ar_ary, xcol, ycol)
    m_regr = regression_formula.first
    y_regr = regression_formula.last
    m_perp = (1 / m_regr * -1)
    distances = []
    points.each do |pair|
      x = pair.first
      y = pair.last
      y_perp = (y - (m_regr * x))
      x_int = ((y_regr - y_perp) / (m_regr - m_perp))
      y_int = ((m_regr * x_int) + y_regr)
      distances << Math.hypot((y_int - y), (x_int - x)).abs
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

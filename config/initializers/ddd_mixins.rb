module AlterColumn

  class ActiveRecord::Base
  
  def self.booleans
    self.columns.select{|c| c.type == :boolean}.map(&:name)
  end
  
  def self.floats
    self.columns.select{|c| c.type == :float}.map(&:name)
  end
  
  def self.integers
    self.columns.select{|c| c.type == :integer}.map(&:name)
  end
  
  def self.strings
    self.columns.select{|c| c.type == :string}.map(&:name)
  end
  
  def self.of_type(type)
    type = type.to_sym
    self.columns.select{|c| c.type == type}.map(&:name)
  end
  
  def self.where_not(opts)
    params = []        
    sql = opts.map{|k, v| params << v; "#{quoted_table_name}.#{quote_column_name k} != ?"}.join(' AND ')
    where(sql, *params)
  end
end
  
def stats(ary, as_pctg=false)
  count = Hash.new(0)
  ary.each do |str|
    count[str] += 1
  end
  stats = count.sort_by{|k, v| v}.reverse
  if as_pctg
    total = ary.count.to_f
    stats.map { |value, freq| [value, freq, (freq.to_f / total * 100).round(1)] }
  else
    stats
  end
end

def mi2m(miles) #miles => meters
  miles.to_f * 1609.34 
end

def m2mi(meters) #meters => miles
  meters.to_f * 0.000621371
end

def driving_distance(to, fro)#, true)
  m2mi(GDirections.new(to, fro, true).distance)
end

#alias_method :mi2m, :miles_to_meters
#alias_method :m2mi, :meters_to_miles

def flat_distance(x1, x2, y1, y2)
  Math.hypot((x2-x1), (y2-y1))
end

def geo_distance(lat1, long1, lat2, long2)
  dtor = Math::PI/180
  r = 6378.14*1000
 
  rlat1 = lat1 * dtor 
  rlong1 = long1 * dtor 
  rlat2 = lat2 * dtor 
  rlong2 = long2 * dtor 
 
  dlon = rlong1 - rlong2
  dlat = rlat1 - rlat2
 
  a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
  c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  d = r * c
 
  d
end

  
module GPSHelper

  def for_google
    coords = self.as_text.split("(").last.split(")").first.split(" ")
    "#{coords.last},#{coords.first}"
  end# of to_s
  def google_link
    url = "https://maps.google.com/maps?hl=en&q=#{self.for_google.gsub(" ", "")}"
  end
  def get_google_earth_ary
    coords = []
    self.exterior_ring.points.each do |point|
      coords << "#{$g.proj_to_geo(point).to_s}, 100"
    end
    coords.join("\n")
  end# of get_google_earth_ary
  def to_gps
    $g.proj_to_geo(self).for_google
  end
end

module RGeo
  module Geos
    class CAPIPointImpl
      include GPSHelper
    end
  end #of Geos module
  module Geographic
    class ProjectedPointImpl
      include GPSHelper
    end# of ProjectedPointImpl class
  end# of Geographic module
  
end# of RGeo

#  def alter_column(table_name, column_name, new_type, mapping, default = nil)
#    drop_default = %Q{ALTER TABLE #{table_name} ALTER COLUMN #{column_name} DROP DEFAULT;}
#    execute(drop_default)
#    # puts drop_default
# 
#    base = %Q{ALTER TABLE #{table_name} ALTER COLUMN #{column_name} TYPE #{new_type} }
#    if mapping.kind_of?(Hash)
#      contains_else = mapping.has_key?("else")
#      else_mapping = mapping.delete("else")
#      when_mapping = mapping.map { |k, v| "when '#{k}' then #{v}" }.join("\n")
#      
#      base += %Q{ USING CASE #{column_name} #{when_mapping} } unless when_mapping.blank?
#      base += %Q{ ELSE #{else_mapping} } unless contains_else.blank?
#      base += %Q{ END } if !when_mapping.blank? or !contains_else.blank?
#    elsif mapping.kind_of?(String)
#      base += mapping
#    end
#    base += ";"
#    
#    execute(base);
#    # puts base
#    
#    unless default.blank?
#      set_default = %Q{ALTER TABLE #{table_name} ALTER COLUMN #{column_name} SET DEFAULT #{default};}
#      execute(set_default)
#      # puts set_default
#    end
#  end
#  module_function :alter_column
# end

##EXAMPLE USAGE IN MIGRATION

#class ChangeTableAttributes < ActiveRecord::Migration
#  class << self
#    include AlterColumn
#  end
# 
#  def self.up
#    alter_column :sometables, :is_numeric, :boolean, { "1" => true, "else" => false }, true
#    alter_column :sometables, :multiplier, :integer, "USING CAST(multiplier AS integer)", 1
#  end
# 
#  def self.down
#    raise ActiveRecord::IrreversibleMigration.new
#  end
#end

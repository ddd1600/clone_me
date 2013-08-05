require 'json'

class LoadJson
  def self.go(classname)
    ary = JSON.parse(File.read(File.join(Rails.root, 'lib', 'assets', "#{classname}.json")))
    column_names = ary.first.keys
    class_r = classname || classname.constantize
    ary.each do |ar_hash|
      r = class_r.new
      column_names.each do |name|
        next if ["owner_full_name", "owner", "owners_pctg"].include?(name)
        eval("r.#{name} = ar_hash['#{name}']")
      end
      r.save
    end
  end
  
end

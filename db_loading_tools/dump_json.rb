class DumpJson
  def self.go(classy)
    ary = classy.all
    name = ary[0].class.name
    File.open(File.join(Rails.root, 'lib', 'assets', "#{name}.json"), 'w') do |f|
      f.write(ary.to_json)
    end
  end
  
  def self.go_specific(ary, classy)
    name = ary[0].class.name
    File.open(File.join(Rails.root, 'lib', 'assets', "#{name}.json"), 'w') do |f|
      f.write(ary.to_json)
    end
  end
end

class ExportAllToJsons
  def initialize
    @classes = [
      "Description", "HalV3", "HalV3Budgeted", "HalV3Derivative", "PisDate", "Property",
      "PropertyDescription", "Regional", "User"
    ]
  end
  
  def go
    @classes.each do |classy|
      eval("DumpJson.go(#{classy})")
    end
  end
end

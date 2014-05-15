require 'multi_json'

require 'dwml/head_extractor'
require 'dwml/data_extractor'

#
# Note: See http://graphical.weather.gov/xml/mdl/XML/Design/MDL_XML_Design.pdf
# for authoritative type definitions
################################################################################

class DWML
  attr_reader :output, :xmldoc

  def initialize(xmldoc)
    @xmldoc = xmldoc
    @output = {}
  end

  def process
    build_head
    build_data
    output
  end

  protected

  def build_head
    extractor = HeadExtractor.new(xmldoc.xpath("//dwml/head").first)
    @output.merge!(extractor.process)
  end

  def build_data
    extractor = DataExtractor.new(xmldoc.xpath("//dwml/data").first)
    @output.merge!(extractor.process)
  end
end

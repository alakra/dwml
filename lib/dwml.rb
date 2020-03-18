require 'dwml/error'
require 'dwml/head_extractor'
require 'dwml/data_extractor'


##
# The DWML class is the main entrypoint for processing DWML Nokogiri
# XML documents.
#
# See
# http://graphical.weather.gov/xml/mdl/XML/Design/MDL_XML_Design.pdf
# for authoritative type definitions
#
# == Usage
#
#  output = DWML.new(nokogiri_xml_doc).process
#
class DWML
  attr_reader :output, :xmldoc

  ##
  # Creates a new instance of the +DWML+ class.
  #
  # @param Nokogiri::XML::Document
  # @return [DWML]
  def initialize(xmldoc)
    @xmldoc = xmldoc
    @output = {}
  end

  ##
  # Processes the associated XML document with +DWML+ object and
  # returns a detailed hash of the weather metrics and also stores it
  # in the +@output+ instance variable.
  #
  # @return [Hash]
  #
  # == Hash Structure
  #
  # The returned hash will have a consistent structure under
  # +:product+ and +:source+ keys. The +:parameters+ value will vary
  # depending on the original XML/DWML document that is passed to
  # +DWML.new+.
  #
  # == Example Output
  #
  #  {:product=>
  #    {:title=>"NOAA's National Weather Service Forecast Data",
  #     :field=>"meteorological",
  #     :category=>"forecast",
  #     :creation_date=>Thu, 05 Mar 2020 18:49:42 UTC +00:00},
  #   :source=>
  #    {:product_center=>
  #      "Meteorological Development Laboratory - Product Generation Branch",
  #     :more_information=>"https://graphical.weather.gov/xml/",
  #     :disclaimer=>"http://www.nws.noaa.gov/disclaimer.html",
  #     :credit=>"https://www.weather.gov/",
  #     :credit_logo=>"https://www.weather.gov/logorequest",
  #     :feedback=>"https://www.weather.gov/contact"},
  #   :parameters=>
  #    {"point1"=>
  #      {:latitude=>38.99,
  #       :longitude=>-77.01,
  #       :temperature=>
  #        {:maximum=>
  #          {:name=>"Daily Maximum Temperature",
  #           :values=>
  #            [{:value=>48.0,
  #              :start_time=>Sat, 07 Mar 2020 12:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Sun, 08 Mar 2020 00:00:00 UTC +00:00},
  #             {:value=>59.0,
  #              :start_time=>Sun, 08 Mar 2020 12:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Mon, 09 Mar 2020 00:00:00 UTC +00:00},
  #             {:value=>68.0,
  #              :start_time=>Mon, 09 Mar 2020 12:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Tue, 10 Mar 2020 00:00:00 UTC +00:00},
  #             {:value=>66.0,
  #              :start_time=>Tue, 10 Mar 2020 12:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Wed, 11 Mar 2020 00:00:00 UTC +00:00},
  #             {:value=>62.0,
  #              :start_time=>Wed, 11 Mar 2020 12:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Thu, 12 Mar 2020 00:00:00 UTC +00:00}]},
  #         :minimum=>
  #          {:name=>"Daily Minimum Temperature",
  #           :values=>
  #            [{:value=>35.0,
  #              :start_time=>Sat, 07 Mar 2020 00:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Sat, 07 Mar 2020 13:00:00 UTC +00:00},
  #             {:value=>31.0,
  #              :start_time=>Sun, 08 Mar 2020 01:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Sun, 08 Mar 2020 13:00:00 UTC +00:00},
  #             {:value=>40.0,
  #              :start_time=>Mon, 09 Mar 2020 00:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Mon, 09 Mar 2020 13:00:00 UTC +00:00},
  #             {:value=>51.0,
  #              :start_time=>Tue, 10 Mar 2020 00:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Tue, 10 Mar 2020 13:00:00 UTC +00:00},
  #             {:value=>48.0,
  #              :start_time=>Wed, 11 Mar 2020 00:00:00 UTC +00:00,
  #              :unit=>"Fahrenheit",
  #              :end_time=>Wed, 11 Mar 2020 13:00:00 UTC +00:00}]}}}}}
  def process
    if @xmldoc.is_a?(Nokogiri::XML::Document)
      build_head
      build_data
      output
    else
      raise DWML::NokogiriDocumentError, "The input is not an Nokogiri::XML::Document"
    end
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

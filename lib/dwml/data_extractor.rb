require 'dwml/location'
require 'dwml/time_layout'
require 'dwml/parameter_extractor'

class DWML
  class DataExtractor
    attr_reader :output, :element

    def initialize(element)
      @element = element
      @locations = []
      @time_layouts = []
      @output = {}
    end

    def process
      extract_locations
      extract_time_layouts
      extract_parameters

      output
    end

    protected

    def extract_locations
      @locations = Location.extract(element.xpath("location"))
    end

    def extract_time_layouts
      @time_layouts = TimeLayout.extract(element.xpath("time-layout"))
    end

    def extract_parameters
      parameters = element.xpath("parameters")

      @output.merge!(
        :parameters => parameters.inject({}) do |memo, parameter|
          location = location_for_parameter(parameter)
          extractor = ParameterExtractor.new(parameter, location, @time_layouts)
          memo.merge!(location.location_key => extractor.process)
          memo
        end
        )
    end

    def location_for_parameter(parameter)
      @locations.detect do |location|
        parameter.attributes["applicable-location"].text == location.location_key
      end
    end
  end
end

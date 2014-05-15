class DWML
  class Location
    class << self
      def extract(elements)
        elements.map { |element| new(element) }
      end
    end

    attr_reader :element, :location_key, :latitude, :longitude

    def initialize(element)
      @element = element

      extract_key
      extract_coords
    end

    protected

    def extract_key
      @location_key = element.xpath("location-key").first.text
    end

    def extract_coords
      point = element.xpath('point').first

      @latitude  = point.attributes["latitude"].text.to_f
      @longitude = point.attributes["longitude"].text.to_f
    end
  end
end

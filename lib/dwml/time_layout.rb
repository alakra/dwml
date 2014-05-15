class DWML
  class TimeLayout
    class << self
      def extract(elements)
        elements.map { |element| new(element) }
      end
    end

    attr_reader :element, :time_coordinate, :summarization, :layout_key, :valid_times

    def initialize(element)
      @element = element
      @valid_times = []

      extract_time_coordinate
      extract_summarization
      extract_layout_key
      extract_valid_times
    end

    protected

    def extract_time_coordinate
      @time_coordinate = element.attributes["time-coordinate"].text
    end

    def extract_summarization
      @summarization = element.attributes["summarization"].text
    end

    def extract_layout_key
      @layout_key = element.xpath("layout-key").first.text
    end

    def extract_valid_times
      start_times = element.xpath("start-valid-time")
      stop_times  = element.xpath("end-valid-time")

      start_times.each_with_index do |start_time, index|
        @valid_times << ValidTime.new(start_time.text, stop_times[index].try(:text))
      end
    end

    class ValidTime
      attr_reader :start, :stop

      def initialize(start, stop)
        @start = Time.zone.parse(start.to_s)
        @stop = Time.zone.parse(stop.to_s)
      end
    end
  end
end

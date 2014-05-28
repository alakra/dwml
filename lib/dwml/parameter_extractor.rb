class DWML
  class ParameterExtractor
    attr_reader :output, :element, :location, :time_layouts

    def initialize(element, location, time_layouts)
      @element      = element
      @location     = location
      @time_layouts = time_layouts

      @output = {
        :latitude  => location.latitude,
        :longitude => location.longitude
      }
    end

    def process
      extract_temperatures
      extract_precipitation
      extract_wind_speed
      extract_wind_direction
      extract_cloud_cover
      extract_probability_of_precipitation
      extract_fire_weather
      extract_convective_hazard
      extract_climate_anomaly
      extract_humidity
      extract_weather
      extract_conditions_icons
      extract_hazards
      extract_water_state

      output
    end

    protected

    def extract_temperatures
      extract_basic_time_series(:temperature)
    end

    def extract_precipitation
      extract_basic_time_series(:precipitation)
    end

    def extract_wind_speed
      extract_basic_time_series(:"wind-speed")
    end

    def extract_wind_direction
      extract_basic_time_series(:direction)
    end

    def extract_cloud_cover
      extract_basic_time_series(:"cloud-amount")
    end

    def extract_probability_of_precipitation
      extract_basic_time_series(:"probability-of-precipitation")
    end

    def extract_humidity
      extract_basic_time_series(:humidity)
    end

    def extract_fire_weather
      extract_basic_time_series(:"fire-weather")
    end

    def extract_water_state
      node = element.xpath("water-state").first
      return if node.blank?

      @output[:"water-state"] = {}
      layout = lookup_time_layout(node)

      waves_node = node.xpath("waves").first
      @output[:"water-state"][:type] = waves_node.attributes["type"].text
      @output[:"water-state"][:unit] = waves_node.attributes["units"].text
      @output[:"water-state"][:values] = []

      waves_node.xpath("value").each_with_index do |value, index|
        @output[:"water-state"][:values] << {
          :value      => value.text,
          :start_time => layout.valid_times[index].start
        }
      end
    end

    def extract_hazards
      node = element.xpath("hazards").first
      return if node.blank?

      layout = lookup_time_layout(node)

      @output[:hazards] = {
        :name => node.xpath("name").first.text,
        :conditions => node.xpath("hazard-conditions").each_with_index.map do |condition_node, index|
          hazard_node = condition_node.xpath("hazard").first
          next if hazard_node.blank?

          {
            :code         => hazard_node.attributes["hazardCode"].text,
            :phenomena    => hazard_node.attributes["phenomena"].text,
            :significance => hazard_node.attributes["significance"].text,
            :type         => hazard_node.attributes["hazardType"].text,
            :url          => hazard_node.xpath("hazardTextURL").first.text,
            :start_time   => layout.valid_times[index].start
          }
        end.compact
      }
    end

    def extract_conditions_icons
      node = element.xpath("conditions-icon").first
      return if node.blank?

      layout = lookup_time_layout(node)

      @output[:"conditions-icon"] = {
        :name  => node.xpath("name").text,
        :type  => node.attributes["type"].text,
        :links => node.xpath("icon-link").each_with_index.map do |icon_node, index|
          {
            :link        => icon_node.text,
            :start_time  => layout.valid_times[index].start
          }
        end
      }
    end

    def extract_convective_hazard
      return if element.xpath("convective-hazard").blank?

      @output[:"convective-hazard"] ||= {
        :outlook => { :name => nil, :values => []},
        :"severe-component" => []
      }

      extract_convective_hazard_outlook
      extract_convective_hazard_severity
    end

    def extract_convective_hazard_outlook
      outlook_node = element.xpath("convective-hazard/outlook").first
      layout = lookup_time_layout(outlook_node)

      @output[:"convective-hazard"][:outlook][:name] = outlook_node.xpath("node").text

      outlook_node.xpath("value").each_with_index do |value, index|
        @output[:"convective-hazard"][:outlook][:values] << {
          :start_time => layout.valid_times[index].start,
          :end_time   => layout.valid_times[index].stop,
          :value      => value.text
        }
      end
    end

    def extract_convective_hazard_severity
      element.xpath("convective-hazard/severe-component").each do |node|
        layout = lookup_time_layout(node)

        hsh = {
          :name   => node.xpath("name").first.text,
          :type   => node.attributes["type"].text,
          :unit   => node.attributes["units"].text,
          :values => node.xpath("value").each_with_index.map do |value, index|
            {
              :value      => value.text,
              :start_time => layout.valid_times[index].start,
              :end_time   => layout.valid_times[index].stop
            }
          end
        }

        @output[:"convective-hazard"][:"severe-component"] << hsh
      end
    end

    def extract_climate_anomaly
      return if element.xpath("climate-anomaly").blank?

      [:weekly, :monthly, :seasonal].each do |period|
        element.xpath("climate-anomaly/#{period.to_s}").each_with_index do |node|
          layout = lookup_time_layout(node)
          valid_time = layout.valid_times.first

          @output[:"climate-anomaly"] ||= {}
          @output[:"climate-anomaly"][period] ||= []
          @output[:"climate-anomaly"][period] << {
            :name       => node.xpath("name").first.text,
            :value      => node.xpath("value").first.text,
            :type       => node.attributes["type"].text,
            :unit       => node.attributes["units"].text,
            :start_time => valid_time.start,
            :end_time   => valid_time.stop
          }
        end
      end
    end

    def extract_weather
      node = element.xpath("weather")
      return if node.blank?

      node.map do |weather_node|
        @output[:weather] ||= {}
        @output[:weather][:name] = weather_node.xpath("name").text
        @output[:weather][:conditions] ||= []

        layout = lookup_time_layout(weather_node)

        weather_node.xpath("weather-conditions").each_with_index do |condition, index|
          value = condition.xpath("value").first
          next if value.blank?

          hsh = { :start_time => layout.valid_times[index].start }

          visibility_node = value.xpath("visibility").first
          if visibility_node.present? && visibility_node.text.present?
            visibility = {
              :unit => visibility_node.attributes["units"].text,
              :value => visibility_node.text.to_f
            }
            hsh.merge!( :visibility => visibility)
          end

          [:coverage, :intensity, :additive, :qualifier, :"weather-type"].each do |key|
            attribute = value.attributes[key.to_s]
            hsh.merge!(key => attribute.to_s) if attribute.present?
          end

          @output[:weather][:conditions] << hsh
        end
      end
    end

    def extract_basic_time_series(metric)
      metric_node = element.xpath(metric.to_s)
      return if metric_node.blank?

      metric_node.map do |node|
        layout = lookup_time_layout(node)
        type = node.attributes["type"].text.to_sym
        unit = node.attributes["units"].try(:text)

        @output[metric] ||= {}
        @output[metric][type] ||= {}
        @output[metric][type][:name] = node.xpath("name").text
        @output[metric][type][:values] = []

        node.xpath("value").each_with_index do |value, index|
          next if value.text.blank?

          hsh = {
            :value      => value.text.to_f,
            :start_time => layout.valid_times[index].start
          }

          end_time = layout.valid_times[index].stop

          hsh.merge!(:unit => unit) if unit.present?
          hsh.merge!(:end_time => end_time) if end_time.present?

          @output[metric][type][:values] << hsh
        end
      end
    end

    def lookup_time_layout(node)
      @time_layouts.detect do |layout|
        node.attributes["time-layout"].text == layout.layout_key
      end
    end
  end
end

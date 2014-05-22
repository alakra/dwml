class DWML
  class HeadExtractor
    attr_reader :output, :element

    def initialize(element)
      @element = element
      @output = {}
    end

    def process
      build_product
      build_source
      output
    end

    protected

    def build_product
      creation_date = Time.zone.parse(element.xpath('product/creation-date').text)

      @output.merge!(
        :product => {
          :title         => normalize_content( 'product/title' ),
          :field         => normalize_content( 'product/field' ),
          :category      => normalize_content( 'product/category' ),
          :creation_date => creation_date
        }
        )
    end

    def build_source
      sub_center = element.xpath('source/production-center/sub-center').text
      production_center = element.xpath('source/production-center').text

      @output.merge!(
        :source => {
          :product_center   => production_center.gsub(sub_center, " - #{sub_center}"),
          :more_information => normalize_content( 'source/more-information' ),
          :disclaimer       => normalize_content( 'source/disclaimer' ),
          :credit           => normalize_content( 'source/credit' ),
          :credit_logo      => normalize_content( 'source/credit-logo' ),
          :feedback         => normalize_content( 'source/feedback' )
        }
        )
    end

    def normalize_content(selector)
      node = element.xpath(selector)

      if node.blank?
        ""
      else
        node.text
      end
    end
  end
end

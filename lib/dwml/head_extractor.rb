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
          :title         => element.xpath('product/title').text,
          :field         => element.xpath('product/field').text,
          :category      => element.xpath('product/category').text,
          :creation_date => creation_date
        }
        )
    end

    def build_source
      sub_center = element.xpath('source/production-center/sub-center').text
      production_center = element.xpath('source/production-center').text

      @output.merge!(
        :source => {
          :more_information => element.xpath('source/more-information').text,
          :product_center   => production_center.gsub(sub_center, " - #{sub_center}"),
          :disclaimer       => element.xpath('source/disclaimer').text,
          :credit           => element.xpath('source/credit').text,
          :credit_logo      => element.xpath('source/credit-logo').text,
          :feedback         => element.xpath('source/feedback').text
        }
        )
    end
  end
end

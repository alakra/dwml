require 'spec_helper'
require 'nokogiri'

describe DWML do
  let(:basic_xml) { File.read("spec/docs/basic.xml") }

  describe ".new" do
    it "creates a new DWML object" do
      doc = Nokogiri::XML.parse(basic_xml)
      expect(DWML.new(doc)).to be_a_kind_of(DWML)
    end
  end

  describe "#process" do
    it "processes an xml document successfully" do
      doc = Nokogiri::XML.parse(basic_xml)
      output = DWML.new(doc).process

      expect(output).to be_a_kind_of(Hash)
      expect(output).to have_key(:product)
      expect(output).to have_key(:source)
      expect(output).to have_key(:parameters)
    end

    it "attempts to process a non-xml document and fails" do
      expect {
        DWML.new("").process
      }.to raise_error(DWML::NokogiriDocumentError)
    end
  end

  describe "attributes" do
    it "can read the original xml document" do
      doc = Nokogiri::XML.parse(basic_xml)
      output = DWML.new(doc).process

      params = output[:parameters]

      expect(params["point1"][:latitude]).to eq(38.99)
      expect(params["point1"][:longitude]).to eq(-77.01)

      temperatures = params["point1"][:temperature]

      expect(temperatures[:maximum][:name]).to eq("Daily Maximum Temperature")
      max_values = temperatures[:maximum][:values].map {|x| x[:value] }
      expect(max_values).to eq([48, 59, 68, 66, 62])

      expect(temperatures[:minimum][:name]).to eq("Daily Minimum Temperature")
      min_values = temperatures[:minimum][:values].map {|x| x[:value] }
      expect(min_values).to eq([35, 31, 40, 51, 48])
    end

    it "can read the cached output" do
      doc = Nokogiri::XML.parse(basic_xml)
      dwml = DWML.new(doc)
      output = dwml.process

      expect(dwml.output).to eq(output)
    end
  end
end

require 'spec_helper'

describe DWML::TimeLayout do
  describe ".extract" do
    it "returns a list of parsed XML elements"
  end

  describe "#element" do
    it "returns the original XML element"
  end

  describe "#time_coordinate" do
    it "returns the extracted time coordinate"
  end

  describe "#summarization" do
    it "returns the extracted summarization"
  end

  describe "#layout_key" do
    it "returns the extracted layout_key"
  end

  describe "#valid_times" do
    it "returns the valid start and stop times as a ValidTime"
  end
end

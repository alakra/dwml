require 'spec_helper'

describe DWML::ParameterExtractor do
  describe "after initialize" do
    describe "#element" do
      it "returns the original XML element"
    end

    describe "#location" do
      it "returns the location"
    end

    describe "#time_layouts" do
     it "returns time layouts"
    end

    describe "#output" do
      it "returns a pair of lat/longs"
    end
  end

  describe "#process" do
    context "for temperatures" do
      it "returns valid temperatures with associated timestamps"
    end

    context "for extracting precipitation" do
      it "returns valid precipitation with associated timestamps"
    end

    context "for extracting wind speed" do
      it "returns valid wind speed with associated timestamps"
    end

    context "for extracting wind direction" do
      it "returns valid wind direction with associated timestamps"
    end

    context "for extracting cloud cover" do
      it "returns valid cloud cover with associated timestamps"
    end

    context "for extracting probability of precipitation" do
      it "returns valid probability of precipitation with associated timestamps"
    end

    context "for extracting fire weather" do
      it "returns valid fire weather with associated timestamps"
    end

    context "for extracting convective hazard" do
      it "returns valid convective hazard with associated timestamps"
    end

    context "for extracting climate anomaly" do
      it "returns valid climate anomaly with associated timestamps"
    end

    context "for extracting humidity" do
      it "returns valid humidity with associated timestamps"
    end

    context "for extracting weather" do
      it "returns valid weather with associated timestamps"
    end

    context "for extracting conditions icons" do
      it "returns valid conditions icons with associated timestamps"
    end

    context "for extracting hazards" do
      it "returns valid hazards with associated timestamps"
    end

    context "for extracting water state" do
      it "returns valid water state with associated timestamps"
    end


  end
end

# dwml [![Gem Version](https://badge.fury.io/rb/dwml.svg)](http://badge.fury.io/rb/dwml) [![Build Status](https://secure.travis-ci.org/alakra/dwml.svg?branch=master)](http://travis-ci.org/alakra/dwml) [![Code Climate](https://codeclimate.com/github/alakra/dwml/badges/gpa.svg)](https://codeclimate.com/github/alakra/dwml)

A parser for NOAA's Digital Weather Markup Language (DWML).

## Requirements

* ruby >= `2.5.x`

## Usage

In your `Gemfile`:

```ruby
gem 'dwml', '~>1.2'
```

In your application:

```ruby
output = DWML.new(nokogiri_xml_doc).process
```

The output will look something like this:

```xml
<?xml version="1.0"?>
<dwml version="1.0" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://graphical.weather.gov/xml/DWMLgen/schema/DWML.xsd">
  <head>
    <product srsName="WGS 1984" concise-name="time-series" operational-mode="official">
      <title>NOAA's National Weather Service Forecast Data</title>
      <field>meteorological</field>
      <category>forecast</category>
      <creation-date refresh-frequency="PT1H">2020-03-18T23:28:22Z</creation-date>
    </product>
    <source>
      <more-information>https://graphical.weather.gov/xml/</more-information>
      <production-center>Meteorological Development Laboratory<sub-center>Product Generation Branch</sub-center></production-center>
      <disclaimer>http://www.nws.noaa.gov/disclaimer.html</disclaimer>
      <credit>https://www.weather.gov/</credit>
      <credit-logo>https://www.weather.gov/logorequest</credit-logo>
      <feedback>https://www.weather.gov/contact</feedback>
    </source>
  </head>
  <data>
    <location>
      <location-key>point1</location-key>
      <point latitude="38.99" longitude="-77.01"/>
    </location>
    <moreWeatherInformation applicable-location="point1">https://forecast-v3.weather.gov/point/38.99,-77.01</moreWeatherInformation>
    <time-layout time-coordinate="local" summarization="none">
      <layout-key>k-p24h-n8-1</layout-key>
      <start-valid-time>2020-03-18T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-18T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-19T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-19T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-20T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-20T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-21T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-21T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-22T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-22T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-23T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-23T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-24T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-24T20:00:00-04:00</end-valid-time>
      <start-valid-time>2020-03-25T08:00:00-04:00</start-valid-time>
      <end-valid-time>2020-03-25T20:00:00-04:00</end-valid-time>
    </time-layout>
    <parameters applicable-location="point1">
      <temperature type="maximum" units="Fahrenheit" time-layout="k-p24h-n8-1">
        <name>Daily Maximum Temperature</name>
        <value>56</value>
        <value>76</value>
        <value>78</value>
        <value>54</value>
        <value>49</value>
        <value>49</value>
        <value>59</value>
        <value>58</value>
      </temperature>
    </parameters>
  </data>
</dwml>
```

## FAQ

### Where do I get DWML documents from?

You can download them directly from the [National Digital Forecast Database (NDFD) Digital Weather Markup Language (DWML) Generator](https://graphical.weather.gov/xml/SOAP_server/ndfdXML.htm).

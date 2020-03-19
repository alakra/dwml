# dwml [![Gem Version](https://badge.fury.io/rb/dwml.svg)](http://badge.fury.io/rb/dwml) [![Build Status](https://secure.travis-ci.org/alakra/dwml.svg?branch=master)](http://travis-ci.org/alakra/dwml) [![Code Climate](https://codeclimate.com/github/alakra/dwml/badges/gpa.svg)](https://codeclimate.com/github/alakra/dwml)

An opinionated parser for NOAA's Digital Weather Markup Language (DWML).

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

```ruby
    {:product=>
      {:title=>"NOAA's National Weather Service Forecast Data",
       :field=>"meteorological",
       :category=>"forecast",
       :creation_date=>Thu, 05 Mar 2020 18:49:42 UTC +00:00},
     :source=>
      {:product_center=>
        "Meteorological Development Laboratory - Product Generation Branch",
       :more_information=>"https://graphical.weather.gov/xml/",
       :disclaimer=>"http://www.nws.noaa.gov/disclaimer.html",
       :credit=>"https://www.weather.gov/",
       :credit_logo=>"https://www.weather.gov/logorequest",
       :feedback=>"https://www.weather.gov/contact"},
     :parameters=>
      {"point1"=>
        {:latitude=>38.99,
         :longitude=>-77.01,
         :temperature=>
          {:maximum=>
            {:name=>"Daily Maximum Temperature",
             :values=>
              [{:value=>48.0,
                :start_time=>Sat, 07 Mar 2020 12:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Sun, 08 Mar 2020 00:00:00 UTC +00:00},
               {:value=>59.0,
                :start_time=>Sun, 08 Mar 2020 12:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Mon, 09 Mar 2020 00:00:00 UTC +00:00},
               {:value=>68.0,
                :start_time=>Mon, 09 Mar 2020 12:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Tue, 10 Mar 2020 00:00:00 UTC +00:00},
               {:value=>66.0,
                :start_time=>Tue, 10 Mar 2020 12:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Wed, 11 Mar 2020 00:00:00 UTC +00:00},
               {:value=>62.0,
                :start_time=>Wed, 11 Mar 2020 12:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Thu, 12 Mar 2020 00:00:00 UTC +00:00}]},
           :minimum=>
            {:name=>"Daily Minimum Temperature",
             :values=>
              [{:value=>35.0,
                :start_time=>Sat, 07 Mar 2020 00:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Sat, 07 Mar 2020 13:00:00 UTC +00:00},
               {:value=>31.0,
                :start_time=>Sun, 08 Mar 2020 01:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Sun, 08 Mar 2020 13:00:00 UTC +00:00},
               {:value=>40.0,
                :start_time=>Mon, 09 Mar 2020 00:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Mon, 09 Mar 2020 13:00:00 UTC +00:00},
               {:value=>51.0,
                :start_time=>Tue, 10 Mar 2020 00:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Tue, 10 Mar 2020 13:00:00 UTC +00:00},
               {:value=>48.0,
                :start_time=>Wed, 11 Mar 2020 00:00:00 UTC +00:00,
                :unit=>"Fahrenheit",
                :end_time=>Wed, 11 Mar 2020 13:00:00 UTC +00:00}]}}}}}
```

## FAQ

### Where do I get DWML documents from?

You can download them directly from the [National Digital Forecast Database (NDFD) Digital Weather Markup Language (DWML) Generator](https://graphical.weather.gov/xml/SOAP_server/ndfdXML.htm).

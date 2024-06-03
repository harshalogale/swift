# SampleQuake
## Features
* Swift app for viewing the latest EarthQuake data
* Real-time data accessed from the USGS Earthquakes repository
* Shows the list of latest earthquakes with color-coded icons depending on intensity
* Shows the earthquakes on the Map view and provides custom annotation to show the details
* Provides a custom view to show the details of the selected view from the table view
* Allows directly opening the Map location view from the details view of any Earthquake entry

## Technical Features
* Swift / UIKit / StoryBoard / MapKit / REST app
* Accesses REST webservices provided by USGS Earthquakes repository: https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson
* Handles GeoJSON response
* Uses UITableView, custom UITableViewCell
* Uses MapKit to show earthquakes view on the global map
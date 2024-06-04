# Spotify Sample
* The app demonstrates basic album search functionality using Spotify public Web API.

## App Features
* Currently, the search is limited to albums but can be easily extended for other types such as -- artists, playlists, tracks, etc.
* Search results are displayed in a table view
* Supports portrait/landscape device rotation
* Allows search result items to be added/removed to/from favorites by left-to-right swipe gesture
* Loads 10 search results by default, automatic next page refresh on scroll down to current end

## Tech Features
* Swift / UIKit / REST App
* Spotify Public API accessed through https://api.spotify.com/v1/
* Supports internationalization (i18n), and has been localized for Marathi (mr-IN) language
* Contains Unit Tests
* 3rd Party MGSwipeTableCell integrated through Objective-C Bridging Header

# ExchangeRate
## Features
* A SwiftUI / Combine / MVVM based iOS app for viewing live Currency Exchange Rates.
* Utilizes [ExchangeRateAPI](http://exchangerate-api.com) web services REST API for accessing live currency exchange rates
* Incorporates views such as `TabView`, `NavigationStack`, `Picker`, `ForEach`, `Text`, `TextField`, `Label`, `ScrollView`, `VStack`, `HStack`, `Button`, `Spacer`
* ConversionRateView -- Find exchange rate from a source currency and a target currency
* ExchangeRatesView -- Find the list of exchange rates from the source currency to all other currencies
* The pickers are pre-populated with the list of supported currencies.
* The supported currency list is read from a json formatted file with an array of (currencyCode, currencyName, country).
* `SFSafariViewController` integration in SwiftUI using `UIViewControllerRepresentable` for in-app display of Docs and Terms web pages.
* Added unit tests for ViewModels
* Mockolo used to generate Swift protocol mocks for testing

## Screenshots
| Screenshot | Description |
| :-----: | :----- |
| <img src="https://github.com/harshalogale/swift/assets/87568874/7d4f9981-1873-4781-b815-185123e848d4" alt="ExchangeRate Screenshot" width=20% height='auto'> | App Icon on Home screen |
| <img src="https://github.com/harshalogale/swift/assets/87568874/555f1643-a160-4616-a341-5900fd13e0b4" alt="ExchangeRate Screenshot" width=20% height='auto'> | Conversion Rate View With Source And Target Selected |
| <img src="https://github.com/harshalogale/swift/assets/87568874/38c6c96b-b6be-43f5-a4c4-84644100e430" alt="ExchangeRate Screenshot" width=20% height='auto'> | Conversion Rate View After Swap Button Is Tapped  |
| <img src="https://github.com/harshalogale/swift/assets/87568874/9f301818-16b2-4bcf-80ae-1eb219654ee3" alt="LikeIt Screenshot" width=20% height='auto'> | Conversion Rate View When Source Amount Has Been Edited |
| <img src="https://github.com/harshalogale/swift/assets/87568874/842988a6-a186-4439-9afc-bd187d2d5dcf" alt="ExchangeRate Screenshot" width=20% height='auto'> | Exchange Rates List View For The Selected Currency |
| <img src="https://github.com/harshalogale/swift/assets/87568874/c2d93904-c092-45a8-9325-39ee2f15d994" alt="ExchangeRate Screenshot" width=20% height='auto'> | Docs Web Page Displayed In-App Using `SFSafariViewController` |
| <img src="https://github.com/harshalogale/swift/assets/87568874/36bdeab0-c767-4bc4-8b05-d560dde9b81d" alt="ExchangeRate Screenshot" width=20% height='auto'> | Terms Web Page Displayed In-App Using `SFSafariViewController` |

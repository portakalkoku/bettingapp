# bettingapp

Betting App is an iOS Application that uses The Odds API. (https://the-odds-api.com/) 

## Structure

Betting App is developed in MVVM style and consists of two screens. Each of them has its ViewModel.

## Usage and Logic

The opening screen of the app is the bulletin screen. From that page, the user can select the league and by selecting it loads the odds of the league.
Selecting odd triggers Cart class which is an RX element.

If Cart has one or more odds in it, then the checkout button becomes visible and active to route to the checkout page.

![](https://github.com/portakalkoku/bettingapp/blob/master/app.gif)

On the checkout page, the user can set a fee to multiply the cart ratio. In addition to that remove a match from the cart.

## Events

The app sends 3 firebase events. On tapping league cell, on adding a match to the cart and removing a match from the cart.

## Unit Test

The app has so many protocols to increase testability. ViewModel classes have UnitTests.

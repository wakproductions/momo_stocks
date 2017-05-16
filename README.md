## Installing Nokogiri

There's an incompatibility with the xz lib installed by homebrew/imagemagick and the call Nokogiri makes to xz when
installing. This gets around the problem.
``
gem install nokogiri -- --with-xml2-include=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/libxml2 --use-system-libraries
``

## Setup for React with ES6

We're using the sprockets-es6 module for handling ES6 compilation. In the future we can use Webpack to make a single
page app front end that's entirely separate from the Rails stuff.

## Idea list

* Notes on ticker changes for the day, so if a ticker was unscraped, it will be noted along with the note on why.
* Archive page of reports (expand list for versions)
* Archive page of institutional ownership / short interest history
* View changes since last report (up/down)

Controller - receive report version id to display that snapshot

## MVP Roadmap

* Get report displays working
* JSON API to receive snapshots
* Provision devops AWS
* Update stock trend finder to increase frequency of the reports and send to momo stocks API
*  
   
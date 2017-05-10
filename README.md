## Installing Nokogiri

There's an incompatibility with the xz lib installed by homebrew/imagemagick and the call Nokogiri makes to xz when
installing. This gets around the problem.
``
gem install nokogiri -- --with-xml2-include=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk/usr/include/libxml2 --use-system-libraries
``
#! /bin/bash

if [ "$1" != "-d" ]; then
    echo "Read the source Luke."
    exit 1
fi

DIR=$(pwd)

rm /usr/lib/ruby/vendor_ruby/robut/plugin/mcollective.rb
rm /usr/lib/ruby/vendor_ruby/robut/plugin/mcollective/iptables.rb

ln -s $DIR/lib/robut/plugin/mcollective.rb /usr/lib/ruby/vendor_ruby/robut/plugin/mcollective.rb
ln -s $DIR/lib/robut/plugin/mcollective/iptables.rb /usr/lib/ruby/vendor_ruby/robut/plugin/mcollective/iptables.rb


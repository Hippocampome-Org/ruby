#!/usr/bin/env sh
gem install json
gem install rb-readline
gem install rchardet19
gem install methadone
gem install highline
gem install mysql2
gem install pry
gem install sequel
gem install outdent

git clone https://github.com/smackesey/csv_port.git
git clone https://github.com/smackesey/biblimatch.git

cd biblimatch
rake install
cd ..
cd csv_port
rake install
cd ..

echo "Successfully installed"

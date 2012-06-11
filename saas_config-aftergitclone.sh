#!/bin/bash
# download rottenpotatoes
#cd ~/Documents
#git clone git://github.com/saasbook/rottenpotatoes
#cd rottenpotatoes
git checkout -b ch_ruby_intro origin/ch_ruby_intro
bundle install

# rails hack to add therubyracer to the default gemfile
cd /usr/local/lib/ruby/gems/1.9.1/gems/railties-3.1.0/lib/rails
sudo chmod 777 generators/
cd generators/
sudo chmod 777 app_base.rb
# this adds gem 'therubyracer' to the default gem file, by it after gem 'uglifier'
sed '/gem '"'uglifier'"'/ a\            gem '"'therubyracer'"'' app_base.rb > app_base2.rb
mv app_base2.rb app_base.rb
sudo chmod 644 app_base.rb
cd ..
sudo chmod 755 generators
cd ~/Documents

# turn off update popups
cd ~/
gconftool -s --type bool /apps/update-notifier/auto_launch false
gconftool -s --type bool /apps/update-notifier/no_show_notifications true


Rising-tide Manager
===========


System environment initialize
-----------
``` shell
mkdir upload
mkdir log
```


Ruby environment initialize
-----------
```shell
gem install bundler
bundle install
```


config Rising-tide Manager
-----------
```shell
mv config/main_example.rb config/main.rb
```
And then, modify this file according to the specific envrionment: config/main.rb


running Rising-tide Manager
-----------
```shell
init.sh start
init.sh stop
init.sh restart
```

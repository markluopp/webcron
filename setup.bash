#!/bin/bash

LinxuDistributor=`lsb_release -i|cut -d: -f2|tr -d '\t'`

# ruby version
ruby -v
if [ ! $? -eq 0 ]; then
    case $LinxuDistributor in
        CentOS)
            sudo yum install ruby
            ;;
        Ubuntu)
            sudo apt-get install ruby
            ;;
        *)
            echo "[Error] Manually install ruby [https://www.ruby-lang.org/zh_cn/documentation/installation/]."
            exit 1
            ;;
    esac
    ruby -v
fi

# rails version
rails -v
if [ ! $? -eq 0 ]; then
    echo "Install rails..."
    gem install rails
fi

# mysql version
mysql --version
if [ ! $? -eq 0 ]; then
    case $LinxuDistributor in
        CentOS)
            sudo yum install mariadb mariadb-server
            ;;
        Ubuntu)
            sudo apt-get install mysql-server
            ;;
        *)
            echo "[Error] Manually install mysql first."
            exit 1
            ;;
    esac
    mysql --version
fi


if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "[Error] Haven't set up two env variables: MYSQL_USER , MYSQL_PASSWORD"
    exit 1
else
    echo "mysql user: $MYSQL_USER"
    echo "mysql password: $MYSQL_USER"
fi

echo "Use bundler to install all required gems..."
# gem mysql2 required libmysqlclient-dev
case $LinxuDistributor in
    CentOS)
        sudo yum install libmysqlclient-dev
        ;;
    Ubuntu)
        sudo apt-get install libmysqlclient-dev
        ;;
    *)
        echo "[Error] gem mysql2 required libmysqlclient-dev package, install it manually."
        exit 1
        ;;
esac

# bundler version
bundle -v 
if [ ! $? -eq 0 ]; then
    echo "Install bundler..."
    gem install bundler
fi

bundle install
if [ ! $? -eq 0 ]; then
    echo "[Error] Can't install all required gems, please check manually!!"
    exit 1
fi

# set up database
rake db:create
rake db:migrate
rake db:seed

YourSecret=`rake secret`
# subsitute secret @ config/secrets.yml
sed -i "s/<your_secret>/${YourSecret}/g" config/secrets.yml
    

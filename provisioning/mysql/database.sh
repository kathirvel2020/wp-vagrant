#!/usr/bin/env bash

# if $wp_db_name is specified, then create the database
if $wp_db_name ; then


  echo "**** creating database"
  mysql -u root -p$mysql_root_password -e "CREATE DATABASE IF NOT EXISTS $wp_db_name;"


  if [ ! -z "$wp_db_user" ]; then
    mysql -u root -p$mysql_root_password -e "GRANT ALL ON $wp_db_name.* TO '$wp_db_user'@'localhost' IDENTIFIED BY '$wp_db_password'"
  fi

  if $deploy_database ; then
    echo "*** importing database dump"
    mysql -u root -p$mysql_root_password $wp_db_name < /vagrant/provisioning/$wp_db_dump_file

    echo "*** wp-cli search and replace"
    wp --path=$wordpress_path --allow-root search-replace $import_site_domain nginx.local
  fi

fi

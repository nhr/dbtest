#!/bin/env ruby

require 'mysql'

begin
  @dbh = Mysql.new ENV['OPENSHIFT_MYSQL_DB_HOST'], ENV['OPENSHIFT_MYSQL_DB_USERNAME'], ENV['OPENSHIFT_MYSQL_DB_PASSWORD'], ENV['OPENSHIFT_APP_NAME'], ENV['OPENSHIFT_MYSQL_DB_PORT'].to_i, ENV['OPENSHIFT_MYSQL_DB_SOCKET']
  puts @dbh.get_server_info
  rs = @dbh.query 'SELECT VERSION()'
  puts rs.fetch_row
rescue Mysql::Error => e
  puts e.errno
  puts e.error
ensure
  @dbh.close if @dbh
end

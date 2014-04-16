#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'helper'


use Rack::Auth::Basic, 'RisingTide_Manager' do |username, password|
  username == 'admin' and password == 'admin'
end


##### Config #####################
set :port, '4567'
set :bind, '127.0.0.1'
set :lock, true
set :sessions, true                     
#set environment, :production
#set :show_exceptions, false
#set :root, File.dirname(__FILE__)          # set application’s root directory to current file's dir
#set :app_file, __FILE__


helpers { include Helpers }
rtide = Helpers::Main.new
##### Routes #####################
get '/test' do
  erb :test
end

get '/' do
  erb :index
end

get '/redis' do
  erb :redis_flush_get
end
post '/redis' do
  params['result'] = rtide.redis_flush(*params['hostname'])
  erb :redis_flush_post
  #params.inspect
  #params['result'].inspect
end

get '/subfile' do
  erb :subfile_get
end
post '/subfile' do
  params['result'] = rtide.subfile(
    params['path'].strip,                   # path(remote server)
    params['myfile'][:tempfile],            # content
    *params['hostname']                     # hostname
  )
  erb :subfile_post
  #params.inspect
end

get '/deploy' do
  erb :deploy_get
end
post '/deploy' do
  #package = params['package']
  #params['result'] = rtide.deploy("v5backup", *package)
  #erb :deploy_post
  params.inspect
end

get '/sync_original_music' do
  erb :sync_original_music_get
end
post '/sync_original_music' do

#  sync = Helpers::SyncOriginalMusic.new(
#    params['id]',
#    'v5backup',
#    'v5db'
#  )

  params['result'] = rtide.mysql_select(params['id'], "v5backup")
  params['result'].inspect
end

get '/daily_work' do
  erb :mail_daily_work_get
end
#post '/daily_work' do
  #content = params['content']
  #hostname = params['hostname'] = $hosts.keys
  #servers = Helpers::MailDailyWork.new(*hostname)
  #servers.check_disk_space
  #servers.check_net_traffic
  #servers.check_process
  #"done"
  #net_traffic = servers.check_net_traffic
  #net_traffic.inspect
  #erb :daily_mail_post
#end




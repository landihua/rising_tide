#!/usr/bin/env ruby
require_relative '../helper'
require_relative '../models/common'
require 'minitest/autorun'

Dir.chdir("../")
puts "app root dir ==> " + Dir.pwd

#include View
#puts "escape_html ==> " + escape_html(" less than: << ||| new line:\n ||| greater than: >>")

puts "\n\n======================================\n\n"

class TestCommon < MiniTest::Unit::TestCase
  def setup
    @hostname = 'v5backup'
    @home_app = '/home/wyy/rising_tide'

    @main = Helpers::Main.new
    @deploy = Helpers::Deploy.new
    @sync_mc_om = Helpers::SyncMcOm.new
  end


  def test_to_ip
    assert_equal '58.215.161.213', @main.to_ip(@hostname)
  end

  def test_ssh
    assert_equal "/etc\n", @main.ssh('ls -d /etc', @hostname)
  end

  def test_uplaod_web
    content0 = "this is a test, #{Time.now}"
    file_content_path = "/home/wyy/test.txt"
    file_uploads_path = "#{@home_app}/uploads/test.txt"
    File.open(file_content_path, 'w') { |f| f.write(content0) }
    content = File.new(file_content_path)
    @main.upload_web("test.txt", content)
    assert_equal content0, File.open(file_uploads_path, 'r') { |f| f.read }
  end

  def test_upload_scp
    assert_equal "*", @main.upload_scp("/u/backup/test.txt", @hostname)
  end

  def test_confile_append
    assert_equal "*", @main.confile_append('api-album.zip', @hostname)
    assert_equal "*", @main.confile_append('web-mc-manager.war', @hostname)
  end

end




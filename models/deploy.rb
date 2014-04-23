#!/usr/bin/env ruby
require_relative 'base'


module Deploy
  class Deploy < Base
    def initialize(packname)
      @packname = packname
      @packname_dotfront = packname.sub(/\..*/, '')
    end

    protected
    def confile_append(hostname)
      package_uri = "upload/#{@packname}"
      confile_uri_system = "upload/#{hostname}-config.properties/#{@packname_dotfront}"
      confile_uri_package = if @packname == "api-album.zip"
                               "#{@packname_dotfront}/config.properties"
                             else
                               "WEB-INF/classes/config.properties"
                             end
      Zip.continue_on_exists_proc = true  # configure rubyzip to overwrite existing files while creating a .zip file
      #Zip::File.open(package_uri, Zip::File::CREATE) do |f|
      Zip::File.open(package_uri) do |f|
        f.add(confile_uri_package, confile_uri_system)
      end
    end

    def update_package(hostname)
      script = <<-EOF
      sudo /u/shscript/update-package/#{@packname_dotfront}.sh
      EOF
      upload_scp("/temp/#{@packname}", hostname)
      ssh(script, hostname)
    end


    public
    def deploy(action)
      if action == (hostname = "v5backup")
        confile_append(hostname)
        update_package(hostname)
      elsif action == "sync"
        case @packname
        when "api-album.zip", "api-yyalbum.war"
          ["v5file", "v5app", "v5app2"].each {|e| update_package(e) }
        else
          update_package("v5file")
        end
      end
    end

  end
end


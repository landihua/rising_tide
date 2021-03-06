#!/usr/bin/env ruby
require_relative 'base'


class V5music
  def initialize(type, ids)  # ids is an Array
    @type, @ids = type, ids
    @types = $types
    @hostname = "tc139"
  end

  protected
  include Base
  def zip_file(id)
    folder = "upload/v5music/#{@type}"
    filenames = {}

    Dir.chdir(folder) do 
      Dir.glob("*").select do |e| 
        if File.directory?(e)
          filenames[e] = Dir.chdir(e) do
            Dir.glob("**/*").select { |ee| File.file?(ee) }
          end
        end 
      end
    end
    # filenames example: {"square"=>["square/index.html", "square/images/03_02.jpg", ], "specialtopic"=>["specialtopic/index.html", "specialtopic/images/wap_02.jpg", "specialtopic/images/wap_01.jpg"]}

    @zipfile = "upload/v5html.zip"
    File.delete(@zipfile) if File.exist?(@zipfile)

    Zip::File.open(@zipfile, Zip::File::CREATE) do |zipf|
      filenames.each do |k, v|
        v.each do |uri| 
          package_uri = "v5html/#{k}/#{id}/#{uri}"
          system_uri = "#{folder}/#{k}/#{uri}"
          zipf.add(package_uri, system_uri)
        end
      end
    end

  end

  public
  def update_localfile(filename, content)
    upload_web(filename, content)

    Zip.on_exists_proc = true
    Zip::File.open("upload/#{filename}") do |zipf|
      zipf.each do |f|
        matchs = @types.join('|')

        if f.name =~ /^(#{matchs})/
          fpath=File.join("upload/v5music", f.name) 
          FileUtils.mkdir_p(File.dirname(fpath))
          zipf.extract(f, fpath)
        end
      end
    end
  end

  def deploy
    result = []
    scp_file_uri = "/temp/v5html.zip"
    @ids.each do |e| 
      zip_file(e)
      upload_scp(scp_file_uri, @hostname)
      re = ssh("sudo unzip -qo #{scp_file_uri} -d /u/mfs", @hostname)
      result << re unless re.nil?
    end
    result
  end

end




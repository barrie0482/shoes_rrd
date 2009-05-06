require "sys/cpu"
include Sys
require 'rrdwrapper'

Shoes.app :title => "CPU Usage Demo",:height => 180, :width => 570 do
  def create_rrd(rrdobject,filename,start)
    rrdobject.create(
      filename,
      "--start", "#{start - 1}",
      "--step", "60",
      "DS:cpu:GAUGE:600:U:U",
      "RRA:LAST:0.5:1:525948") unless File.exist?(@filename)
  end

  def update_image(rrdobject,pngfile,sample_time,sample_seconds,filename)
    rrdobject.graph(
      "#{pngfile}",
      "--title", " \"CPU Usage Demo\"",
      "--start", sample_time.to_i - sample_seconds.to_i,
      "--end", "#{sample_time}",
      "--interlace",
      "--imgformat", "PNG",
      "--width=450",
      "--upper-limit=100",
      "--lower-limit=0",
      "--vertical-label","%cpu",
      "DEF:cpu=#{filename}:cpu:LAST",
      "AREA:cpu#0022e9:%cpu")
  end
  # You will need to change paths to suit your system.
  # This has only been tested on win32.
  #################################################################
  ENV["RRD_DEFAULT_FONT"] = 'D:/projects/shoes_rrd/bin/DejaVuSansMono-Roman.ttf'
  @f = Rrdwrapper.new('D:/projects/shoes_rrd/bin/rrdtool.exe')
  # Note: the rrdpath variable cannot use a path with a colon. 
  # rrdtool uses the colon as a delimiter in some fields.
  # The rrdpath needs to be on the same drive where the program is running
  rrdpath = '/shoes_rrd'
  #################################################################
  name = "cpu"
  rrddir = "#{rrdpath}/rra"
  rrd = "#{name}.rrd"
  @filename = "#{rrddir}/#{rrd}"
  start = Time.now.to_i
  pngfile = "#{name}_#{Time.now.to_i}.png"
  create_rrd(@f,@filename,start)
  sample_seconds = 3600
	sample_time = @f.last(@filename)
	@f.update(@filename, "#{sample_time}:#{CPU.load_avg.to_s}")
	update_image(@f,pngfile,sample_time,sample_seconds,@filename) 
  @cpu = image Dir.glob('cpu*.png').last
  every(60) do
    sample_time = Time.now.to_i
    @f.update(@filename, "#{sample_time}:#{CPU.load_avg.to_s}")
	  sample_seconds = 3600
    update_image(@f,pngfile,sample_time,sample_seconds,@filename)
    @cpu.remove
    @cpu = image Dir.glob('cpu*.png').last
    File.delete(pngfile)
    pngfile = "cpu_#{Time.now.to_i}.png"
  end
end  

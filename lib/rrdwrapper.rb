# = rrdwrapper.rb
#  rrdwrapper is a wrapper around the rrdtool executable.
#
#  At present, rrdwrapper has only been tested on win32. It should work with
#  minor changes on Linux and Mac. It has been tested with RRDTool v1.2.x.
#  I haven't tried it with RRDTool v1.3.x as I can't compile it on win32. :-)
#
#  TODO - not all rrdtool functions have been implemented
# 
#  Copyright (c) 2009 Barrie Hill
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#
#
#
#
class Rrdwrapper
  # rrdcmd sets the full path to the rrdtool executable
  #
  #  Rrdwrapper.new(rrdcmd)
  # === Example
  #  f = Rrdwrapper.new('D:/projects/rrdtool/rrdtool.exe')
  attr_reader :rrdcmd
  
  # Create a new rrdwrapper object
  #
  # You should set the rrd default font using a command similar to the example
  # below. You may not get text on your graphs if you don't.
  #
  #  ENV["RRD_DEFAULT_FONT"] = 'D:/projects/rrdtool/DejaVuSansMono-Roman.ttf'
  #
  # === Example
  #  ENV["RRD_DEFAULT_FONT"] = 'D:/projects/rrdtool/DejaVuSansMono-Roman.ttf'
  #  f = Rrdwrapper.new('D:/projects/rrdtool/rrdtool.exe')
  def initialize(rrdcmd)
    @rrdcmd = rrdcmd
  end

  # Set up a new Round Robin Database
  #
  #  create filename([--start|-b start time] [--step|-s step] [DS:ds-name:DST:dst arguments] [RRA:CF:cf arguments])
  #
  #  This method uses standard rrdtool create arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   start = Time.now.to_i
  #   f.create(
  #   "#{rrddir}/#{rrd}",
  #   "--start", "#{start - 1}",
  #   "--step", "300",
  #   "DS:a:GAUGE:600:U:U",
  #   "DS:b:GAUGE:600:U:U",
  #   "RRA:AVERAGE:0.5:1:300")
  #
  def create(filename,*args)
    %x{#{@rrdcmd} create #{filename} #{args.join(' ')}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect 
  end

  # Update a Round Robin Database
  #
  #  update filename(filename,[--template|-t ds-name[:ds-name]...],N|timestamp:value[:value...],at-timestamp@value[:value...],[timestamp:value[:value...] ...])
  #
  #  This method uses standard rrdtool update arguments separated by commas. Refer to the rrdtool documentation for details.
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   puts "updating #{rrd}"
  #   start.to_i.step(start.to_i + 300 * 300, 300) { |i|
  #      f.update("#{rrddir}/#{rrd}", "#{i}:#{rand(100)}:#{Math.sin(i / 800) * 50 + 50}")
  #   }
  def update(filename,*args)
     %x{#{@rrdcmd} update #{filename} #{args.join(' ')}}
     #puts "******* #{@rrdcmd} update #{filename} #{args.join(' ')} ********"
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Update a Round Robin Database
  #
  #  updatev(filename,[--template|-t ds-name[:ds-name]...],N|timestamp:value[:value...],at-timestamp@value[:value...],[timestamp:value[:value...] ...]
  #
  #  This method uses standard rrdtool update arguments separated by commas. Refer to the rrdtool documentation for details.
  #  This alternate version of update takes the same arguments and performs the same function. The v stands for verbose.
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   puts "updating #{rrd}"
  #   start.to_i.step(start.to_i + 300 * 300, 300) { |i|
  #      f.updatev("#{rrddir}/#{rrd}", "#{i}:#{rand(100)}:#{Math.sin(i / 800) * 50 + 50}")
  #   }
  def updatev(filename,*args)
    %x{#{@rrdcmd} update #{filename} #{args.join(' ')}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Graph a Round Robin Database
  #
  #  graph(filename,[option ...],[data definition ...],[data calculation ...],[variable definition ...],[graph element ...],[print element ...])
  # 
  #  This method uses standard rrdtool graph arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # 
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   xml = "#{name}.xml"
  #   start = Time.now.to_i
  #   rrdend = start + 1000*60
  #   png = "#{name}.png"
  #  f.graph(
  #  "#{rrddir}/#{png}",
  #  "--title", " /"RubyRRD Demo/"",
  #  "--start", "#{start+3600}",
  #  "--end", "#{rrdend}",
  #  "--interlace",
  #  "--imgformat", "PNG",
  #  "--width=450",
  #  "DEF:a=#{rrddir}/#{rrd}:a:AVERAGE",
  #  "DEF:b=#{rrddir}/#{rrd}:b:AVERAGE",
  #  "CDEF:line=TIME,2400,%,300,LT,a,UNKN,IF",
  #  "AREA:b#00b6e4:beta",
  #  "AREA:line#0022e9:alpha",
  #  "LINE3:line#ff0000")
  def graph(filename,*args)
    %x{#{@rrdcmd} graph #{filename} #{args.join(' ')}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Dump the contents of an RRD to XML format
  #
  #  dump(filename.rrd,filename.xml)
  #
  #  This method uses standard rrdtool dump arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   xml = "#{name}.xml"
  #  f.dump("#{rrddir}/#{rrd}","#{rrddir}/#{xml}")
  def dump(filename,xmlfilename)
    xmlarray = %x[#{@rrdcmd} dump #{filename}]
    f = File.open("#{xmlfilename}", "w")
    xmlarray.each { |line| f.puts line }
    f.close 
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Restore the contents of an RRD from its XML dump format
  #
  #  restore(filename.xml,filename.rrd,[--range-check|-r])
  #
  #  This method uses standard rrdtool restore arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   xml = "#{name}.xml"
  #   f.restore("#{rrddir}/#{xml}", "#{rrddir}/new.rrd")
  def restore(xmlfilename,rrdfilename,*args)
    %x{#{@rrdcmd} restore #{xmlfilename} #{rrdfilename} #{args.join(' ')}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Fetch data from an RRD.
  #
  #  fetch(filename,CF,[--resolution|-r resolution],[--start|-s start],[--end|-e end])
  #
  #  This method uses standard rrdtool fetch arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #  name = "test"
  #  rrdpath = '/tmp'
  #  rrddir = "#{rrdpath}/rra"
  #  rrd = "#{name}.rrd"
  #  xml = "#{name}.xml"
  #  start = Time.now.to_i
  #  data = f.fetch("#{rrddir}/#{rrd}", "AVERAGE", "--start", start.to_s, "--end",(start + 10000).to_s)
  #  puts "got #{data.length} data points"     # from #{fstart} to #{fend}"
  #  puts data

  def fetch(filename,cf,*args)
    %x[#{@rrdcmd} fetch #{filename} #{cf} #{args.join(' ')}].to_a
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Return the date of the first data sample in an RRA within an RRD
  #
  #  first(filename,[--rraindex number])
  #
  #  This method uses standard rrdtool first arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   xml = "#{name}.xml"
  #   f.first("#{rrddir}/#{rrd}")
  def first(filename,*args)
    %x{#{@rrdcmd} first #{filename} #{args.join(' ')}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect    
  end
 
  # Return the date of the last data sample in an RRD
  #
  #  last filename)
  #
  #  This method uses standard rrdtool last arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   xml = "#{name}.xml"
  #   f.last("#{rrddir}/#{rrd}")
  def last(filename)
    %x{#{@rrdcmd} last #{filename}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end

  # Extract header information from an RRD
  #
  #  info(filename.rrd)
  #
  #  This method uses standard rrdtool info arguments separated by commas. Refer to the rrdtool documentation for details.
  #
  #  Ruby variables can be used.
  # === Example
  #   name = "test"
  #   rrdpath = '/projects/rrdtool'
  #   rrddir = "#{rrdpath}/rra"
  #   rrd = "#{name}.rrd"
  #   f.info("#{rrddir}/#{rrd}")
  def info(filename)
    %x{#{@rrdcmd} info #{filename}}
  rescue Exception => e 
    puts e.message 
    puts e.backtrace.inspect
  end
end


 
#  RRD_TEST.RB is a simple script designed to illustrate how rrdwrapper works.
#  At present, rrdwrapper has only been tested on win32. It should work with
#  minor changes on Linux and Mac. It has been tested with RRDTool v1.2.x.
#  I haven't tried it with RRDTool v1.3.x as I can't compile it on win32. :-)
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
#  The script creates 
#  * a RRD
#  * populates the RRD with test data
#  * produces a png graph
#  * extracts the RRD data to an xml file
#  * creates a new RRD from the XML
#  * produces a png graph from the new RRD
#  * fetches a number of data points from the RRD
#  * returns the date of the first data sample in RRD and the new RRD
#  * returns the date of the last data sample in RRD and the new RRD
#  * extract header information from the RRD
#
#      require 'rrdwrapper'
#      ENV["RRD_DEFAULT_FONT"] = 'D:/bin/DejaVuSansMono-Roman.ttf'
#      f = Rrdwrapper.new('D:/bin/rrdtool.exe')
#      name = "test"
#      rrdpath = '/tmp'
#      rrddir = "#{rrdpath}/rra"
#      rrd = "#{name}.rrd"
#      xml = "#{name}.xml"
#      start = Time.now.to_i
#      rrdend = start + 1000*60
#      png = "#{name}.png"
#      puts start
#      puts rrdend
#     #
#     # Test rrdtool create
#     #
#      f.create(
#      "#{rrddir}/#{rrd}",
#      "--start", "#{start - 1}",
#      "--step", "300",
#      "DS:a:GAUGE:600:U:U",
#      "DS:b:GAUGE:600:U:U",
#      "RRA:AVERAGE:0.5:1:300")
#     #
#     # Test rrdtool update
#     #
#      puts "updating #{rrd}"
#      start.to_i.step(start.to_i + 300 * 300, 300) { |i|
#        f.update("#{rrddir}/#{rrd}", "#{i}:#{rand(100)}:#{Math.sin(i / 800) * 50 + 50}")
#      }
#      puts
#   #
#   # Test rrdtool graph
#   #
#     puts "generating graph #{rrddir}/#{png}"
#     f.graph(
#     "#{rrddir}/#{png}",
#     "--title", " \"RRDWrapper Demo\"",
#     "--start", "#{start+3600}",
#     "--end", "#{rrdend}",
#     "--interlace",
#     "--imgformat", "PNG",
#     "--width=450",
#     "DEF:a=#{rrddir}/#{rrd}:a:AVERAGE",
#     "DEF:b=#{rrddir}/#{rrd}:b:AVERAGE",
#     "CDEF:line=TIME,2400,%,300,LT,a,UNKN,IF",
#     "AREA:b#00b6e4:beta",
#     "AREA:line#0022e9:alpha",
#     "LINE3:line#ff0000")
#     puts
#    #
#    # Test rrdtool dump - write rrd to xml file
#    #
#      puts "dumping rrd file to #{rrddir}/#{xml}"
#      f.dump("#{rrddir}/#{rrd}","#{rrddir}/#{xml}")
#    #
#    # Test rrdtool restore - write xml to rrd file
#    #
#      puts "restoring rrd file to #{rrddir}/new.rrd"
#      f.restore("#{rrddir}/#{xml}", "#{rrddir}/new.rrd")
#      puts
#    #
#    # Test rrdtool graph
#    #
#      puts "generating graph #{rrddir}/#{png}"
#      f.graph(
#      "#{rrddir}/new.png",
#      "--title", " \"RRDWrapper Restore Demo\"",
#      "--start", "#{start+3600}",
#      "--end", "#{rrdend}",
#      "--interlace",
#      "--imgformat", "PNG",
#      "--width=450",
#      "DEF:a=#{rrddir}/new.rrd:a:AVERAGE",
#      "DEF:b=#{rrddir}/new.rrd:b:AVERAGE",
#      "CDEF:line=TIME,2400,%,300,LT,a,UNKN,IF",
#      "AREA:b#00b6e4:beta",
#      "AREA:line#0022e9:alpha",
#      "LINE3:line#ff0000")
#      puts
#    #
#    # Test rrdtool fetch
#    #
#       puts "fetching data from #{rrd}"
#       data = f.fetch("#{rrddir}/#{rrd}", "AVERAGE", "--start", start.to_s, "--end",(start + 10000).to_s)
#       puts "got #{data.length} data points from #{fstart} to #{fend}"
#       puts data
#       puts
#    #
#    # Test rrdtool first
#    #
#      puts "rrdtool first - returns the date of the first data sample in #{rrd}"
#      f.first("#{rrddir}/#{rrd}")
#      puts "rrdtool first - returns the date of the first data sample in new.rrd"
#      f.first("#{rrddir}/new.rrd")
#    #
#    # Test rrdtool last
#    #
#      puts "rrdtool last - returns the date of the last data sample in #{rrd}"
#      f.last("#{rrddir}/#{rrd}")
#      puts "rrdtool last - returns the date of the last data sample in #{rrd}"
#      f.last("#{rrddir}/new.rrd")
#    #
#    # Test rrdtool info
#    #
#      puts "rrdtool info - extract header information from #{rrd}"
#      puts "rrdtool info #{rrd}"
#      f.info("#{rrddir}/#{rrd}")
#      puts
#      puts "Your test files are located in #{rrddir}"
#      puts "Delete or move them before you run this program again"


require 'rrdwrapper'
ENV["RRD_DEFAULT_FONT"] = 'D:/bin/DejaVuSansMono-Roman.ttf'
f = Rrdwrapper.new('D:/bin/rrdtool.exe')
name = "test"
rrdpath = '/tmp'
rrddir = "#{rrdpath}/rra"
rrd = "#{name}.rrd"
xml = "#{name}.xml"
start = Time.now.to_i
rrdend = start + 1000*60
png = "#{name}.png"
puts start
puts rrdend
#
# Test rrdtool create
#
f.create(    
  "#{rrddir}/#{rrd}",
  "--start", "#{start - 1}",
  "--step", "300",
  "DS:a:GAUGE:600:U:U",
  "DS:b:GAUGE:600:U:U",
  "RRA:AVERAGE:0.5:1:300")
#
# Test rrdtool update
#
puts "updating #{rrd}"
start.to_i.step(start.to_i + 300 * 300, 300) { |i|
  f.update("#{rrddir}/#{rrd}", "#{i}:#{rand(100)}:#{Math.sin(i / 800) * 50 + 50}")
}
puts


#
# Test rrdtool graph
#
puts "generating graph #{rrddir}/#{png}"
f.graph(
  "#{rrddir}/#{png}",
  "--title", " \"RRDWrapper Demo\"",
  "--start", "#{start+3600}",
  "--end", "#{rrdend}",
  "--interlace", 
  "--imgformat", "PNG",
  "--width=450",
  "DEF:a=\"#{rrddir}/#{rrd}\":a:AVERAGE",
  "DEF:b=\"#{rrddir}/#{rrd}\":b:AVERAGE",
  "CDEF:line=TIME,2400,%,300,LT,a,UNKN,IF",
  "AREA:b#00b6e4:beta",
  "AREA:line#0022e9:alpha",
  "LINE3:line#ff0000")
puts
#
# Test rrdtool dump - write rrd to xml file
#
puts "dumping rrd file to #{rrddir}/#{xml}"
f.dump("#{rrddir}/#{rrd}","#{rrddir}/#{xml}")
#
# Test rrdtool restore - write xml to rrd file
#
puts "restoring rrd file to #{rrddir}/new.rrd"
f.restore("#{rrddir}/#{xml}", "#{rrddir}/new.rrd")
puts
#
# Test rrdtool graph
#
puts "generating graph #{rrddir}/#{png}"
f.graph(
  "#{rrddir}/new.png",
  "--title", " \"RRDWrapper Restore Demo\"",
  "--start", "#{start+3600}",
  "--end", "#{rrdend}",
  "--interlace", 
  "--imgformat", "PNG",
  "--width=450",
  "DEF:a=\"#{rrddir}/new.rrd\":a:AVERAGE",
  "DEF:b=\"#{rrddir}/new.rrd\":b:AVERAGE",
  "CDEF:line=TIME,2400,%,300,LT,a,UNKN,IF",
  "AREA:b#00b6e4:beta",
  "AREA:line#0022e9:alpha",
  "LINE3:line#ff0000")
puts
#
# Test rrdtool fetch
#
puts "fetching data from #{rrd}"
data = f.fetch("#{rrddir}/#{rrd}", "AVERAGE", "--start", start.to_s, "--end",(start + 10000).to_s)
puts "got #{data.length} data points"     # from #{fstart} to #{fend}"
puts data
puts
#
# Test rrdtool first
#
      puts "rrdtool first - returns the date of the first data sample in #{rrd}"
      f.first("#{rrddir}/#{rrd}")
      puts "rrdtool first - returns the date of the first data sample in new.rrd"
      f.first("#{rrddir}/new.rrd")
    #
    # Test rrdtool last
    #
      puts "rrdtool last - returns the date of the last data sample in #{rrd}"
      f.last("#{rrddir}/#{rrd}")
      puts "rrdtool last - returns the date of the last data sample in #{rrd}"
      f.last("#{rrddir}/new.rrd")
#
# Test rrdtool info
#
puts "rrdtool info - extract header information from #{rrd}"
f.info("#{rrddir}/#{rrd}")
puts
puts "Your test files are located in #{rrddir}"
puts "Delete or move them before you run this program again"

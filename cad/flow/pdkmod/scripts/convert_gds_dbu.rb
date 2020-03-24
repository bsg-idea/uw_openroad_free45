# Description: Read a GDS file and convert the DBU to 0.0005
# Input Parameters:
#   -rd in=<input gds>
#   -rd out=<output gds>

layout = RBA::Layout.new
layout.read($in)
options = RBA::SaveLayoutOptions::new
options.dbu = 0.0005
layout.write($out, false, options)


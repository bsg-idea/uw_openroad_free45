
#=================================================
# Create a layer map for conversion to gds
#=================================================

layer_map = RBA::LayerMap::new

layer_map.map("OUTLINE : 235/0", 0)

(1..10).each do |i|
  layer_map.map("metal" + i.to_s + " : "       + (i*2+9).to_s + "/0", i)
  layer_map.map("metal" + i.to_s + ".LABEL : " + (i*2+9).to_s + "/0", i)
  layer_map.map("metal" + i.to_s + ".PIN : "   + (i*2+9).to_s + "/0", i)
end

(1..9).each do |i|
  layer_map.map("via" + i.to_s + " : "       + (i*2+10).to_s + "/0", i+10)
  layer_map.map("via" + i.to_s + ".LABEL : " + (i*2+10).to_s + "/0", i+10)
  layer_map.map("via" + i.to_s + ".PIN : "   + (i*2+10).to_s + "/0", i+10)
end

#=================================================
# Load in the lef/def layout
#=================================================

puts "INFO: Opening LEF/DEF files..."
puts "INFO: \tDEF=" + $in_def
puts "INFO: \tLEF (relative to DEF)=" + $in_lef

main_layout = RBA::Layout.new
options = RBA::LoadLayoutOptions::new
lefdef_options = RBA::LEFDEFReaderConfiguration::new
lefdef_options.lef_files = [$in_lef]
lefdef_options.layer_map = layer_map
lefdef_options.dbu = 0.0005
options.lefdef_config = lefdef_options
main_layout.read($in_def, options)

#=================================================
# Clear cells
#=================================================

top_cell_index = main_layout.cell($design_name).cell_index()
(0..(main_layout.cells-1)).each do |i|
  if i != top_cell_index
    cname = main_layout.cell_name(i)
    if not main_layout.cell_name(i).start_with?("VIA")
      puts "INFO: Clearing cell '" + cname + "'"
      main_layout.cell(i).clear()
    end
  end
end

#=================================================
# Load in the gds to merge
#=================================================

puts "INFO: Merging gds file '" + $in_gds + "'"
main_layout.read($in_gds)

#=================================================
# Copy the top level only to a new layout
#=================================================

puts "INFO: Copying toplevel cell '" + $design_name + "'"
top_only_layout = RBA::Layout.new
top_only_layout.dbu = 0.0005
top = top_only_layout.create_cell($design_name)
top.copy_tree(main_layout.cell($design_name))

#=================================================
# Write out the gds
#=================================================

puts "INFO: Write out gds '" + $out_gds + "'"
top_only_layout.write($out_gds)


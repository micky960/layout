 createInstGroup ti_buf_group_top
 createInstGroup ti_buf_group_bottom
 set tot_size [sizeof_collection [get_cells u_key_logic*buf_inst]]
 set count 0
 foreach_in_collection c [get_cells u_key_logic*buf_inst] {
 set name [get_object_name $c ]
	if { [expr { fmod ($count,2)}] == 0 } {
 		addInstToInstGroup ti_buf_group_bottom $name 
	} else {
		addInstToInstGroup ti_buf_group_top $name
	}
 }
 createFence ti_buf_group 5 5 65 10
 createFence ti_buf_group 5 55 65 65


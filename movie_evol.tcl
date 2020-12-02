set blend [lindex $argv 0]
set outfile [lindex $argv 1]
set path [pwd]
set savepath $path

set dir pbctools-directory
source $dir/pkgIndex.tcl
package require pbctools

set start 0
set end 10000000
set increment 10000

set filename [format "dump.%d" [expr $start]]
mol new $filename type {lammpstrj} first 0 last -1 step 1 waitfor 1
animate style loop

incr start $increment
print $start
for {set i $start} {$i <= $end} {incr i $increment} {
	set filename [format "dump.%d" [expr $i]]
	mol addfile $filename type {lammpstrj} first 0 last -1 step 1 waitfor 1 0
	animate style loop}

mol modcolor 0 0 Type
mol modstyle 0 0 VDW 0.3 12.0
mol material Opaque

# type A
mol addrep 0
if {$blend == 1} {
	mol modselect 1 0 type 1 3
} else {
	mol modselect 1 0 type 1
}

# type B
mol addrep 0
if {$blend == 1} {
	mol modselect 2 0 type 2 4
} else {
	mol modselect 2 0 type 2
}

# substrate
mol addrep 0
if {$blend == 1} {
	mol modselect 3 0 type 5 6
} else {
	mol modselect 3 0 type 3 4
}

# representation
mol modcolor 1 0 Type
mol modstyle 1 0 VDW 0.3 12.0
mol material Opaque

mol modcolor 2 0 Type
mol modstyle 2 0 VDW 0.3 12.0
mol material Opaque

mol modcolor 3 0 Type
mol modstyle 3 0 VDW 0.3 12.0
mol material Opaque

if {$blend == 0} {
    color Type 1 yellow
    color Type 2 purple
    color Type 3 gray
    color Type 4 gray
} elseif {$blend == {L}} {
    color Type 1 green
    color Type 2 magenta2
    color Type 3 gray
    color Type 4 gray
} elseif {$blend == 1} {
    color Type 1 yellow
    color Type 2 purple
    color Type 3 magenta2
    color Type 4 green
    color Type 5 gray
    color Type 6 gray
} elseif {$blend == {I}} {
    color Type 1 purple
    color Type 2 yellow
    color Type 3 gray
    color Type 4 gray
}

display projection Orthographic
display height 4.000000

#display resize 822 768
display resize 1156 1080
scale by 1.1

#pbc box -color black -width 1.0
color Display Background white
axes location off

set fps 24
set total_frame [expr ($end - $start)/$increment + 1]

mol showrep 0 0 0
mol showrep 0 2 0
for {set i 1} {$i <= $total_frame} {incr i 1} {
	animate goto $i

	set outfile_index [format ".%.4d.ppm" [expr $i]]
	set outfile_fullname $savepath/$outfile$outfile_index

	render TachyonInternal $outfile_fullname
}

ffmpeg -an -i $savepath/$outfile.%4d.ppm -vcodec mpeg2video -r $fps -vframes $total_frame -vb 20M -filter:v "se

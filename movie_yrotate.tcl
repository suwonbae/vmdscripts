set blend [lindex $argv 0]
set outfile [lindex $argv 1]
set infile [lindex $argv 2]
set path [pwd]
set savepath $path
set infile_fullname $path/$infile

set dir pbctools-directory
source $dir/pkgIndex.tcl
package require pbctools

mol new $infile_fullname type {lammpstrj} first 0 last -1 step 1 waitfor 1
animate style Loop

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
mol modstyle 1 0 QuickSurf 0.500000 0.500000 0.500000 2.000000
mol material Opaque

mol modcolor 2 0 Type
mol modstyle 2 0 VDW 0.3 12.0
mol material Opaque

mol modcolor 3 0 Type
mol modstyle 3 0 VDW 0.3 12.0
mol material Opaque

color Type 1 yellow
color Type 2 purple
if {$blend == 1} {
	color Type 3 yellow
	color Type 4 purple
	color Type 5 gray
	color Type 6 gray
} else {
	color Type 3 gray
	color Type 4 gray
}

display projection Orthographic
display height 4.000000

pbc box -color black -width 1.0
color Display Background white
axes location off

mol modmaterial 2 0 Transparent
material change opacity Transparent 0.08

# visualization 1
mol showrep 0 0 0
## use below to not show 2
mol showrep 0 2 0
## use below to not show 3
#mol showrep 0 3 0
## use below to show periodic image of 3
#mol showperiodic 0 3 xyXY
#mol numperiodic 0 3 1

#display resize 822 768
display resize 1156 1080

set rotation_angle 360.0
set fps 24
set duration 4
set total_frame [expr $fps*$duration]

set angle_per_frame [expr $rotation_angle/$total_frame]

display resetview
for {set i 0} {$i < $total_frame} {incr i 1} {
	display resetview
	rotate z by [expr $angle_per_frame*$i]
	rotate z by -140
	rotate x by -60
	scale by 1.1

	set outfile_index [format ".%.4d.ppm" [expr $i]]
	set outfile_fullname $savepath/$outfile$outfile_index

	render TachyonInternal $outfile_fullname

        }

#convert -delay  4.17 -loop 4 $savepath/untitled.*.ppm $savepath/untitled.gif
ffmpeg -an -i $savepath/$outfile.%4d.ppm -vcodec mpeg2video -r 24 -vframes $total_frame -vb 20M $savepath/$outfile.mpg

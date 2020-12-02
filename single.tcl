# vmd -dispdev text -args < ~/Documents/vmdscripts/single.tcl 0 dump.10000000

set blend [lindex $argv 0]
set name [lindex $argv 1]
#set name test.lammpstrj
#set path /Users/suwonbae/Documents/bcp/fene/image/temp
#set savepath /Users/suwonbae/Documents/bcp/fene/image/temp
#set name dump.10000000
set path [pwd]
set savepath $path
set fullname $path/$name

mol new $fullname type {lammpstrj} first 0 last -1 step 1 waitfor 1
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
mol modcolor 0 0 Type
mol modstyle 0 0 VDW 0.3 12.0
mol material Opaque

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
	color Type 3 green
	color Type 4 magenta2
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

color Display Background white
axes location off

# visualization 1
mol showrep 0 0 0

scale by 1.25

render TachyonInternal $savepath/top.png

rotate x by 180

render TachyonInternal $savepath/bottom.png

display resetview
scale by 1.25

rotate y by -90
rotate z by -90

render TachyonInternal $savepath/side+.png

rotate y by 180

render TachyonInternal $savepath/side-.png

# visualzation 2
mol showrep 0 1 1
mol showrep 0 2 0

display resetview
scale by 1.25

render TachyonInternal $savepath/top_1.png

mol showrep 0 1 0
mol showrep 0 2 1

render TachyonInternal $savepath/top_2.png

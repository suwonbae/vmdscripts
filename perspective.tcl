set blend [lindex $argv 0]
set name [lindex $argv 1]
#set name test.lammpstrj
#set path /Users/suwonbae/Documents/bcp/fene/image/temp
#set savepath /Users/suwonbae/Documents/bcp/fene/image/temp
#set name dump.10000000
set path [pwd]
set savepath $path
set fullname $path/$name

set dir pbctools-directory
source $dir/pkgIndex.tcl
package require pbctools

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

pbc box -color black -width 1.0
#pbc box -color black -width 1.0 -shiftcenter {0 0 19.83}
color Display Background white
axes location off

mol modmaterial 2 0 Transparent
material change opacity Transparent 0.08

# visualization 1
mol showrep 0 0 0
## use below to not show 2
#mol showrep 0 2 0
## use below to not show 3
#mol showrep 0 3 0
## use below to show periodic image of 3
#mol showperiodic 0 3 xyXY
#mol numperiodic 0 3 1

rotate z by -140
rotate x by -60
#display resize 822 768
display resize 1156 1080
scale by 1.1

render TachyonInternal $savepath/iso.png

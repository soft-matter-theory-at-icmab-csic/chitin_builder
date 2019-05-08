#
# Chitin builder gui
#
package require psfgen
package provide chitin 1.0

namespace eval ::chitin:: {
    variable w
    variable crystal
    variable xdim
    variable ydim
    variable zdim
    variable perio
    variable ormat
<<<<<<< HEAD
    variable already_registered 0
=======
>>>>>>> 26967e470bc202474da10e90387821b2e6cc766b

}
##################################################
### Crystal replication procedures ###############
# Return a list with atom positions.
proc extractPdbCoords {pdbFile} {
	set r {}
	
	# Get the coordinates from the pdb file.
	set in [open $pdbFile r]
	foreach line [split [read $in] \n] {
		if {[string equal [string range $line 0 3] "ATOM"]} {
			set x [string trim [string range $line 30 37]]
			set y [string trim [string range $line 38 45]]
			set z [string trim [string range $line 46 53]]
			
			lappend r [list $x $y $z]
		}
	}
	close $in
	return $r
}

# Extract all atom records from a pdb file.
proc extractPdbRecords {pdbFile} {
	set in [open $pdbFile r]
	
	set pdbLine {}
	foreach line [split [read $in] \n] {
		if {[string equal [string range $line 0 3] "ATOM"]} {
			lappend pdbLine $line
		}
	}
	close $in	
	
	return $pdbLine
}

# Shift a list of vectors by a lattice vector.
proc displaceCell {rUnitName i1 i2 i3 a1 a2 a3} {
	upvar $rUnitName rUnit
	# Compute the new lattice vector.
	set rShift [vecadd [vecscale $i1 $a1] [vecscale $i2 $a2]]
	set rShift [vecadd $rShift [vecscale $i3 $a3]]
	
	set rRep {}
	foreach r $rUnit {
		lappend rRep [vecadd $r $rShift]
	}
	return $rRep
}

# Construct a pdb line from a template line, index, resId, and coordinates.
proc makePdbLine {template index resId r} {
	foreach {x y z} $r {break}
	set record "ATOM  "
	set si [string range [format "     %5i " $index] end-5 end]
	set temp0 [string range $template 12 21]
	set resId [string range "    $resId"  end-3 end]
	set temp1 [string range $template  26 29]
	set sx [string range [format "       %8.3f" $x] end-7 end]
	set sy [string range [format "       %8.3f" $y] end-7 end]
	set sz [string range [format "       %8.3f" $z] end-7 end]
	set tempEnd [string range $template 54 end]

	# Construct the pdb line.
	return "${record}${si}${temp0}${resId}${temp1}${sx}${sy}${sz}${tempEnd}"
}

# Build the crystal.
proc replicate {n1 n2 n3 crys per} {
    if {$n1*$n2*$n3*2>9999} {
	error "to many residues! reduce x, y or z"
    }
    if {$crys=="Alpha"} {
    
        # Input pdb with 4 molecules (double unit cell)
        set unitCellPdb ./structures/alpha-4residues.pdb
        # Output (create output file)
        set outPdb crystal-alpha.pdb
        # The dimensions of the unit cell are standard in l1 and l3 and double in l2
        # because the pdb structure is duplicated in the l2 direction 
        # (4 molecules in pdb instead of 2 molecules in original unit cell)
        set l1 4.75
        set l2 18.890
        set l3 10.333
        set basisVector1 [list 1.0 0.0 0.0]
        set basisVector2 [list 0.0 1.0 0.0]
        set basisVector3 [list 0.0 0.0 1.0]
    }
        if {$crys=="Beta"} {
    
        # Input pdb with 4 molecules (double unit cell)
        set unitCellPdb ./structures/beta-4residues.pdb
        # Output (create output file)
        set outPdb crystal-beta.pdb
        # The dimensions of the unit cell are standard in l1 and l3 and double in l2
        # because the pdb structure is duplicated in the l2 direction 
        # (4 molecules in pdb instead of 2 molecules in original unit cell)
	set l1 9.638
	set l2 19.276
	set l3 10.384
	set basisVector1 [list 1.0 0.0 0.0]
	set basisVector2 [list 0.125 0.992 0.0]
	set basisVector3 [list 0.0 0.0 1.0]
    }
	set out [open $outPdb w]
	puts $out "REMARK Unit cell dimensions:"
	puts $out "REMARK a1 $l1" 
	puts $out "REMARK a2 $l2" 
	puts $out "REMARK a3 $l3" 
	puts $out "REMARK Basis vectors:"
	puts $out "REMARK basisVector1 $basisVector1" 
	puts $out "REMARK basisVector2 $basisVector2" 
	puts $out "REMARK basisVector3 $basisVector3" 
	puts $out "REMARK replicationCount $n1 $n2 $n3" 
	
	set a1 [vecscale $l1 $basisVector1]
	set a2 [vecscale $l2 $basisVector2]
	set a3 [vecscale $l3 $basisVector3]
	
	set rUnit [extractPdbCoords $unitCellPdb]
	set pdbLine [extractPdbRecords $unitCellPdb]
        puts "\nReplicating unit $unitCellPdb cell $n1 by $n2 by $n3..."

        set ll1 27
		
	# Replicate the unit cell.
	set atom 1
        set resId 1
        for {set i 0} {$i < $n1} {incr i} {
	    for {set j 0} {$j < $n2} {incr j} {
		for {set k 0} {$k < $n3} {incr k} {
				set rRep [displaceCell rUnit $i $j $k $a1 $a2 $a3]
				
				# Write each atom.
				foreach r $rRep l $pdbLine {
					puts $out [makePdbLine $l $atom $resId $r]
				    incr atom

				}
				incr resId
				
				if {$resId > 9999} {
					puts "Warning! Residue overflow."
					set resId 1
				}								
			}
		}
	}
	puts $out "END"
	close $out
	
    puts "The file $outPdb was written successfully."
    psf_gen $n1 $n2 $n3 $crys $per
       
}
##################################################################
##################################################################
##########PSF generation
proc psf_gen {n1 n2 n3 crys1 per1} {
    resetpsf
    if {$crys1=="Alpha"} {
	#load replicated structure
	mol new crystal-alpha.pdb 
	set idm [molinfo top get id]
	#mult is the number of chitin residues per chain 
	# 2*n3 
	set mult [expr $n3*2]
	#atnum is the number of atoms per chitin residue that will be generated
	set atnum 27
	#chnum number of chitin chains (the cell contain 2 chains * n1 * n2 )

	set chnum [expr 2*$n1*$n2]

	#loop over the structure to fix resid necessary to apply patches
	for {set i 0} {$i<$chnum} {incr i} {
	    #each fragment is a chitin chain
	    set sel1 [atomselect $idm "fragment $i"]
	    #generates a pdb per each chain
	    $sel1 writepdb fragment_$i.pdb
	    #load the chain fragment
	    mol new fragment_$i.pdb
	    set tot [atomselect top all]
	    #loop over each residue to fix resid
	    #this loop employs the known number of atoms per resid which is atnum
	    # each group of atnum atoms has a different resid
	    for {set j 0} {$j<$mult} {incr j} {
		set ind1 [expr $j*$atnum]
		set ind2 [expr $atnum + $j*$atnum-1]
		set sel [atomselect top "index $ind1 to $ind2"]
		$sel set resid $j
	    }
	    #generates a pdb of each fixed chain fragment
	    $tot writepdb fragment_$i-r.pdb
	    #rm fragment_$i.pdb
	    file delete fragment_$i.pdb
	    mol delete top
	}
	mol delete top
	#load topology file for psfgen
	topology bGLC.top
	#The order of residues is complicated and maybe it is possible to fixed it in a better way.
	#The order comes from the replicate code.
	#The loops are over each pdb chain to apply patch (patch 14bb: glycosidic bond 1-4)
	#Note that this require the index of two residues in specific order
	
	#Even chain fragments have this order of residues:
	# 1 0 3 2 .. 5 4 7 6 ... So require a loop for even and odd numbers
	for {set j 0} {$j<$chnum} {incr j 2} {
	    segment M$j {pdb fragment_$j-r.pdb}
	    #loop for even numbers
	    for {set i 0} {$i<[expr $mult-1]} {incr i 2} {
		patch 14bb M$j:$i M$j:[expr $i + 1]
	    }
	    #loop for odd numbers
	    for {set i 0} {$i<[expr $mult-2]} {incr i 2} {
		patch 14bb   M$j:[expr $i + 3] M$j:$i
	    }
	    #patch to generate periodic bond at the end
	    if {$per1=="yes"} {
		patch 14bb M$j:1 M$j:[expr $mult-2]
	    }
	    coordpdb fragment_$j-r.pdb M$j
	    regenerate angles dihedrals
	    guesscoord
	}
    
	#Odd chain fragments have this order of residues:
	# 0 1 2 3 ... so require only one loop
	for {set j 1} {$j<$chnum} {incr j 2} {
	    segment M$j {pdb fragment_$j-r.pdb}
	    #loop for odd and even numbers
	    for {set i 0} {$i<[expr $mult-1]} {incr i} {
		patch 14bb M$j:$i M$j:[expr $i + 1]
	    }
	    #patch to generate periodic bond at the end
	    if {$per1=="yes"} {
		patch 14bb M$j:[expr $mult-1] M$j:0
	    }
	    coordpdb fragment_$j-r.pdb M$j
	    regenerate angles dihedrals
	    guesscoord
	}
	#final structure psf and pdb
	writepsf crystal-alpha-psf.psf
	writepdb crystal-alpha-psf.pdb
	#remove intermediate files
	for {set i 0} {$i<$chnum} {incr i} {
	    #    rm fragment_$i-r.pdb
	    file delete fragment_$i-r.pdb
	}
	mol new crystal-alpha-psf.psf
	mol addfile crystal-alpha-psf.pdb type pdb
    }
    if {$crys1=="Beta"} {
	#load replicated structure
	mol new crystal-beta.pdb
	set idm [molinfo top get id]
	#mult is the number of chitin residues per chain (the cell contain 2 residues per chain * c=6 == 12)
	set mult [expr $n3*2]
	#atnum is the number of atoms per chitin residue
	set atnum 27
	#chnum number of chitin chains (the cell contain 2 chains * a=8 * b=2 == 32)
	set chnum [expr $n1*$n2*2]

	#loop over the structure to fix resid necessary to apply patches
	for {set i 0} {$i<$chnum} {incr i} {
	    #each fragment is a chitin chain
	    set sel1 [atomselect $idm "fragment $i"]
	    #generates a pdb per each chain
	    $sel1 writepdb fragment_$i.pdb
	    #load the chain fragment
	    mol new fragment_$i.pdb
	    set tot [atomselect top all]
	    #loop over each residue to fix resid
	    for {set j 0} {$j<$mult} {incr j} {
		set ind1 [expr $j*$atnum]
		set ind2 [expr $atnum + $j*$atnum-1]
		set sel [atomselect top "index $ind1 to $ind2"]
		$sel set resid $j
	    }
	    #generates a pdb of each fixed chain fragment
	    $tot writepdb fragment_$i-r.pdb
	    #rm fragment_$i.pdb
	    file delete fragment_$i.pdb
	    mol delete top
	}
	mol delete top
	#load topology file for psfgen
	topology bGLC.top
	#The order comes from the replicate code.
	#The loops are over each pdb chain to apply patch (patch 14bb: glycosidic bond 1-4)
	#Note that this require the index of two residues in specific order
	#Chain fragments have this order of residues:
	# 0 1 2 3 ... so require only one loop
	for {set j 0} {$j<$chnum} {incr j} {
	    segment M$j {pdb fragment_$j-r.pdb}
	    #loop for odd and even numbers
	    for {set i 0} {$i<[expr $mult-1]} {incr i} {
		patch 14bb M$j:[expr $i + 1] M$j:$i 
	    }
	    #patch to generate periodic bond at the end
	    if {$per1=="yes"} {
		patch 14bb M$j:0 M$j:[expr $mult-1]
	    }
	    coordpdb fragment_$j-r.pdb M$j
	    regenerate angles dihedrals
	    guesscoord
	}
	#final structure psf and pdb
	writepsf crystal-beta-psf.psf
	writepdb crystal-beta-psf.pdb
	#remove intermediate files
	for {set i 0} {$i<$chnum} {incr i} {
	    # rm fragment_$i-r.pdb
	    file delete fragment_$i-r.pdb
	}
	mol new crystal-beta-psf.psf
	mol addfile crystal-beta-psf.pdb type pdb
    }
}

#################################################################
proc ::chitin::chitin_gui {} {
    variable w
    variable crystal
    variable xdim
    variable ydim
    variable zdim

    #not sure what is this if for
    if { [winfo exists .chitin] } {
        wm deiconify $w
        return
    }

    #window title
    set w [toplevel ".chitin"]
    wm title $w "Chitin Builder"
    wm resizable $w yes yes
    wm geometry $w 500x173
    set row 0

    set ::chitin::crystal "Alpha"
    set ::chitin::xdim 1
    set ::chitin::ydim 1
    set ::chitin::zdim 1
    set ::chitin::perio "yes"
    set ::chitin::ormat "PSF + PDB"                                                           
    #Add a menubar
    frame $w.menubar -relief raised -bd 2
    grid  $w.menubar -padx 1 -column 0 -columnspan 4 -row $row -sticky ew
    menubutton $w.menubar.help -text "Help" -underline 0 \
    -menu $w.menubar.help.menu
    $w.menubar.help config -width 81
    pack $w.menubar.help -side right
    menu $w.menubar.help.menu -tearoff no
    $w.menubar.help.menu add command -label "About" \
    -command {tk_messageBox -type ok -title "About Chitin" \
    -message "Chitin builder tool by D C Malapina and J Faraudo. Institut de Ciencia de Materials de Barcelona (ICMAB-CSIC). please cite"}
    $w.menubar.help.menu add command -label "Documentation..." \
    -command "vmd_open_url ..."
    incr row

    #Select the lipid to use
    grid [label $w.crystalpicklab -text "Crystal allomorph: "] \
    -row $row -column 0 -sticky w
    grid [menubutton $w.crystalpick -textvar ::chitin::crystal \
    -menu $w.crystalpick.menu -relief raised] \
    -row $row -column 1 -columnspan 3 -sticky ew
    menu $w.crystalpick.menu -tearoff no
    $w.crystalpick.menu add command -label "Alpha" \
    -command {set ::chitin::crystal "Alpha" }
    incr row
    $w.crystalpick.menu add command -label "Beta" \
    -command {set ::chitin::crystal "Beta" }
    incr row
    
    grid [label $w.mwlabel -text "Times to replicate in x: "] \
    -row $row -column 0 -columnspan 3 -sticky w
    grid [entry $w.mw -width 7 -textvariable ::chitin::xdim] -row $row -column 3 -columnspan 1 -sticky ew
    incr row

    grid [label $w.mhlabel -text "Times to replicate in y: "] \
    -row $row -column 0 -columnspan 3 -sticky w
    grid [entry $w.mh -width 7 -textvariable ::chitin::ydim] -row $row -column 3 -columnspan 1 -sticky ew
    incr row

    grid [label $w.mzlabel -text "Times to replicate in z: "] \
    -row $row -column 0 -columnspan 3 -sticky w
    grid [entry $w.mz -width 7 -textvariable ::chitin::zdim] -row $row -column 3 -columnspan 1 -sticky ew
    incr row

    #Select periodic bonds
    grid [label $w.periopicklab -text "Periodic bonds in topology: "] \
    -row $row -column 0 -sticky w
    grid [menubutton $w.periopick -textvar ::chitin::perio \
    -menu $w.periopick.menu -relief raised] \
    -row $row -column 1 -columnspan 3 -sticky ew
    menu $w.periopick.menu -tearoff no
    $w.periopick.menu add command -label "yes" \
    -command {set ::chitin::perio "yes" }
    $w.periopick.menu add command -label "no" \
    -command {set ::chitin::perio "no"}
    incr row

    #Select periodic bonds
    grid [label $w.outplab -text "Output format: "] \
    -row $row -column 0 -sticky w
    grid [menubutton $w.outp -textvar ::chitin::ormat \
    -menu $w.outp.menu -relief raised] \
    -row $row -column 1 -columnspan 3 -sticky ew
    menu $w.outp.menu -tearoff no
    $w.outp.menu add command -label "PSF + PDB" \
    -command {set ::chitin::ormat "PSF + PDB" }
    $w.outp.menu add command -label "XYZ" \
	-command {set ::chitin::ormat "XYZ"}
    $w.outp.menu add command -label "GRO + TOP" \
	-command {set ::chitin::ormat "GRO + TOP"}
    incr row
    
    grid [button $w.gobutton -text "Generate crystal" \
      -command [namespace code {
        replicate "$xdim" "$ydim" "$zdim" "$crystal" "$perio"
      } ]] -row $row -column 0 -columnspan 4 -sticky nsew

}

# Register menu if possible
proc chitin::register_menu {} {
    variable already_registered
    if {$already_registered==0} {
	incr already_registered
	vmd_install_extension chitin chitin_tk "Modeling/Chitin Builder"
    }
}

proc chitin_tk {} {
  ::chitin::chitin_gui
  return $::chitin::w
}




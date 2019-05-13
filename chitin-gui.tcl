#
# Chitin builder gui
#
package require psfgen
#package require pbctools
package provide chitin 1.0

namespace eval ::chitin:: {
    variable w
    variable crystal
    variable xdim
    variable ydim
    variable zdim
    variable perio
    variable ormat
    variable avalue
    variable bvalue
    variable cvalue
    variable aangle
    variable bangle
    variable paper
    variable xv1
    variable xv2
    variable yv1
    variable zv3
    variable bv1
    variable bv2
    variable already_registered 0

}
##################################################
### Crystal replication procedures ###############
# Return a list with atom positions.
proc ::chitin::extractPdbCoords {pdbFile} {
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
proc ::chitin::extractPdbRecords {pdbFile} {
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
proc ::chitin::displaceCell {rUnitName i1 i2 i3 a1 a2 a3} {
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
proc ::chitin::makePdbLine {template index resId r} {
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
proc ::chitin::replicate {n1 n2 n3 crys per} {
    
    if {$n1*$n2*$n3*2>9999} {
	error "to many residues! reduce x, y or z"
    }
    global env
    puts $env(CHITINDIR)
    if {$crys=="Alpha"} {
    
        # Input pdb with 4 molecules (double unit cell)
        set unitCellPdb $env(CHITINDIR)/structures/alpha-4residues.pdb

        # Output (create output file)
        set outPdb crystal-alpha-temp.pdb
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
        set unitCellPdb $env(CHITINDIR)/structures/beta-4residues.pdb
        # Output (create output file)
        set outPdb crystal-beta-temp.pdb
        # The dimensions of the unit cell are standard in l1 and l3 and double in l2
        # because the pdb structure is duplicated in the l2 direction 
        # (4 molecules in pdb instead of 2 molecules in original unit cell)
	set l1 9.638
	set l2 18.478
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
	

    ::chitin::file_gen $n1 $n2 $n3 $crys $per

    #Draw pbcbox


    
    puts "--------------------------------"
    puts "Files crystal-????-psf.psf & crystal-????-psf.pdb"
    puts "were written successfully"
    puts "--------------------------------"
    puts "Cell vectors:"
    puts "$::chitin::xv1 $::chitin::xv2 $::chitin::xv2"
    puts "$::chitin::yv1 $::chitin::yv2 $::chitin::xv2"
    puts "$::chitin::xv2 $::chitin::xv2 $::chitin::zv3"
    puts "--------------------------------"  
}
##################################################################
##################################################################
##########PSF generation
proc ::chitin::file_gen {n1 n2 n3 crys1 per1} {
    resetpsf
    global env
    if {$crys1=="Alpha"} {
	#load replicated structure
	mol new crystal-alpha-temp.pdb 
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
	topology $env(CHITINDIR)/structures/top_all36_carb.rtf
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
	#pbc set {$::chitin::avalue $::chitin::bvalue $::chitin::cvalue $::chitin::aangle $::chitin::aangle $::chitin::bangle} -vmd
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
	mol new crystal-beta-temp.pdb
	set idm [molinfo top get id]
	#mult is the number of chitin residues per chain (the cell contain 2 residues per chain * c=6 == 12)
	set mult [expr $n3*2]
	#atnum is the number of atoms per chitin residue
	set atnum 27
	#chnum number of chitin chains (the cell contain 2 chains * a=8 2 chains* b=2 == 32)
	set chnum [expr 2*$n1*$n2*2]

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
	topology $env(CHITINDIR)/structures/top_all36_carb.rtf
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
	#topo writevarxyz crystal-beta-xyz.xyz [atomselect top all]
    }

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
    ::chitin::chitin_gui_new
    return $::chitin::w

}

#################################
# GENERATED GUI PROCEDURES
#

proc ::chitin::chitin_gui_new {} {
    variable w
    variable crystal
    variable xdim
    variable ydim
    variable zdim
    variable avalue
    variable bvalue
    variable cvalue
    variable aangle
    variable bangle
    variable paper
    variable xv1
    variable xv2
    variable yv1
    variable yv2
    variable zv3
    variable bv1
    variable bv2
    set ::chitin::crystal "Alpha"
    set ::chitin::xdim 1
    set ::chitin::ydim 1
    set ::chitin::zdim 1
    set ::chitin::perio "yes"
    set ::chitin::avalue 4.750
    set ::chitin::bvalue 18.890
    set ::chitin::cvalue 10.333
    set ::chitin::aangle 90.0
    set ::chitin::bangle 90.0
    set ::chitin::paper "(Biomacromolecules, 2009, 10 (5), pp 1100–1105)"
    set ::chitin::xv1 0.0
    set ::chitin::xv2 0.0
    set ::chitin::yv1 0.0
    set ::chitin::yv2 0.0
    set ::chitin::zv3 0.0
    set ::chitin::bv1 0.0
    set ::chitin::bv2 1.0
    if { [winfo exists .chitin] } {
        wm deiconify $w
        return
    }
    #create window    
    set w [toplevel ".chitin"]
    ###################
    # CREATING WIDGETS
    ###################
    #vTcl::widgets::core::toplevel::createCmd $top -class Toplevel \
	#    -menu {} -background {#d9d9d9} -highlightcolor black 
    wm focusmodel $w passive
    wm geometry $w 600x509+498+302
    update
    # set in toplevel.wgt.
    wm maxsize $w 1905 1170
    wm minsize $w 1 1
    wm overrideredirect $w 0
    wm resizable $w 1 1
    wm deiconify $w
    wm title $w "Chitin Builder v1.0"
    

    ####menu
    frame $w.fra43 \
        -borderwidth 2 -relief groove -background {#d9d9d9} -height 35 \
        -width 610 
     menubutton $w.fra43.help -text "Help" -underline 0 \
	    -menu $w.fra43.help.menu
     $w.fra43.help config -width 40
     pack $w.fra43.help -side right
     menu $w.fra43.help.menu -tearoff no
     $w.fra43.help.menu add command -label "About" \
     -command {tk_messageBox -type ok -title "About Chitin" \
     -message "Chitin builder tool by D C Malapina and J Faraudo. Institut de Ciencia de Materials de Barcelona (ICMAB-CSIC). please cite"}
     $w.fra43.help.menu add command -label "Documentation..." \
     -command "vmd_open_url https://bitbucket.org/icmab_soft_matter_theory/chitin_builder_gui/src/master/ "

    #####Select crystal
	    

     menubutton $w.crystalpick -textvar ::chitin::crystal \
	    -menu $w.crystalpick.menu -relief raised
     #$w.crystalpick config -width 20
#     -row $row -column 1 -columnspan 3 -sticky ew
     menu $w.crystalpick.menu -tearoff no
     $w.crystalpick.menu add command -label "Alpha" \
	    -command {set ::chitin::crystal "Alpha"; set ::chitin::avalue 4.750; set ::chitin::bvalue 18.890; \
			  set ::chitin::cvalue 10.333 ; set ::chitin::bangle 90.0 ; \
			  set ::chitin::bv1 0.0 ; set ::chitin::bv2 1.0 ; \
			  set ::chitin::paper "(Biomacromolecules, 2009, 10 (5), pp 1100–1105)"}
#     incr row
     $w.crystalpick.menu add command -label "Beta" \
	    -command {set ::chitin::crystal "Beta"; set ::chitin::avalue 4.819; set ::chitin::bvalue 9.239; \
			  set ::chitin::cvalue 10.384; set ::chitin::bangle 97.16; \
			  set ::chitin::bv1 0.250 ; set ::chitin::bv2 1.984 ; \
			  set ::chitin::paper "(Macromolecules, 2011, 44 (4), pp 950–957)     " }
	    
	    
#     #Select periodic bonds
#     grid [label $w.periopicklab -text "Periodic bonds in topology: "] \
#     -row $row -column 0 -sticky w
	    #     grid [
      menubutton $w.periopick -textvar ::chitin::perio \
	    -menu $w.periopick.menu -relief raised
#     -row $row -column 1 -columnspan 3 -sticky ew
      menu $w.periopick.menu -tearoff no
      $w.periopick.menu add command -label "yes" \
     -command {set ::chitin::perio "yes" }
     $w.periopick.menu add command -label "no" \
     -command {set ::chitin::perio "no"}

    #vTcl:DefineAlias "$w" "Toplevel1" #vTcl:Toplevel:WidgetProc "" 1
    frame $w.fra45 \
        -borderwidth 2 -relief groove -background {#d9d9d9} -height 225 \
        -highlightcolor black -width 560 
    #vTcl:DefineAlias "$w.fra45" "Frame1" #vTcl:WidgetProc "Toplevel1" 1
    set site_3_0 $w.fra45
    label $site_3_0.lab59 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -text {Unit cell:} 
    #vTcl:DefineAlias "$site_3_0.lab59" "Label3" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab60 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
			 -highlightcolor black -text {Cell vectors [Angstrom]:} 
    #vTcl:DefineAlias "$site_3_0.lab60" "Label4" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab61 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -text {a =

b =

c =} 
    #vTcl:DefineAlias "$site_3_0.lab61" "Label5" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab64 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify right \
        -text {alpha =

beta  =

gamma =} 
    #vTcl:DefineAlias "$site_3_0.lab64" "Label6" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab68 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -text {Cell parameters from: } 
    #vTcl:DefineAlias "$site_3_0.lab68" "Label7" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab70 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
	-highlightcolor black -textvariable ::chitin::avalue 
    #vTcl:DefineAlias "$site_3_0.lab70" "Label8" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab71 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::bvalue 
    #vTcl:DefineAlias "$site_3_0.lab71" "Label8_7" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab72 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::cvalue 
    #vTcl:DefineAlias "$site_3_0.lab72" "Label8_8" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab73 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
	-highlightcolor black -textvariable ::chitin::aangle 
    #vTcl:DefineAlias "$site_3_0.lab73" "Label8_9" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab74 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::aangle 
    #vTcl:DefineAlias "$site_3_0.lab74" "Label8_10" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab75 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::bangle
    #vTcl:DefineAlias "$site_3_0.lab75" "Label8_11" #vTcl:WidgetProc "Toplevel1" 1
    label $site_3_0.lab77 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify left \
        -textvariable ::chitin::paper 
    #vTcl:DefineAlias "$site_3_0.lab77" "Label9" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab78 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
			 -highlightcolor black -textvariable ::chitin::xv1
    label $w.lab78b \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
			 -highlightcolor black -textvariable ::chitin::xv2
    label $w.lab78c \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
	-highlightcolor black -textvariable ::chitin::xv2
    #vTcl:DefineAlias "$site_3_0.lab78" "Label8_12" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab79 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::yv1
    label $w.lab79b \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
			 -highlightcolor black -textvariable ::chitin::yv2
    label $w.lab79c \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::xv2
	    #vTcl:DefineAlias "$site_3_0.lab79" "Label8_13" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab80 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::xv2
    label $w.lab80b \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::xv2
    label $w.lab80c \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -textvariable ::chitin::zv3
	    #vTcl:DefineAlias "$site_3_0.lab80" "Label8_1" #vTcl:WidgetProc "Toplevel1" 1
    place $site_3_0.lab59 \
        -in $site_3_0 -x 10 -y 5 -anchor nw -bordermode ignore 
    place $w.lab60 \
        -in $w -x 30 -y 380 -width 198 -relwidth 0 -height 18 \
        -relheight 0 -anchor nw -bordermode ignore 
    place $site_3_0.lab61 \
        -in $site_3_0 -x 140 -y 5 -width 46 -relwidth 0 -height 76 \
        -relheight 0 -anchor nw -bordermode ignore 
    place $site_3_0.lab64 \
        -in $site_3_0 -x 320 -y 10 -anchor nw -bordermode ignore 
    place $site_3_0.lab68 \
        -in $site_3_0 -x 100 -y 90 -anchor nw -bordermode ignore 
    place $site_3_0.lab70 \
        -in $site_3_0 -x 190 -y 12 -anchor nw -bordermode ignore 
    place $site_3_0.lab71 \
        -in $site_3_0 -x 180 -y 28 -width 43 -relwidth 0 -height 28 \
        -relheight 0 -anchor nw -bordermode ignore 
    place $site_3_0.lab72 \
        -in $site_3_0 -x 180 -y 58 -width 43 -height 18 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab73 \
        -in $site_3_0 -x 390 -y 7 -width 43 -height 18 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab74 \
        -in $site_3_0 -x 390 -y 31 -width 43 -height 18 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab75 \
        -in $site_3_0 -x 390 -y 55 -width 43 -height 18 -anchor nw \
        -bordermode ignore 
    place $site_3_0.lab77 \
        -in $site_3_0 -x 200 -y 90 -width 321 -relwidth 0 -height 18 \
        -relheight 0 -anchor nw -bordermode ignore 
    place $w.lab78 \
        -in $w -x 210 -y 400 -width 110 -relwidth 0 -height 18 \
	    -relheight 0 -anchor nw -bordermode ignore
    place $w.lab78b \
        -in $w -x 310 -y 400 -width 110 -relwidth 0 -height 18 \
	    -relheight 0 -anchor nw -bordermode ignore
    place $w.lab78c \
        -in $w -x 410 -y 400 -width 110 -relwidth 0 -height 18 \
        -relheight 0 -anchor nw -bordermode ignore 
    place $w.lab79 \
        -in $w -x 210 -y 430 -width 110 -height 18 -anchor nw \
        -bordermode ignore 
    place $w.lab79b \
        -in $w -x 310 -y 430 -width 110 -height 18 -anchor nw \
        -bordermode ignore 
    place $w.lab79c \
        -in $w -x 410 -y 430 -width 110 -height 18 -anchor nw \
        -bordermode ignore 
    place $w.lab80 \
        -in $w -x 210 -y 460 -width 110 -height 18 -anchor nw \
	    -bordermode ignore
    place $w.lab80b \
        -in $w -x 310 -y 460 -width 110 -height 18 -anchor nw \
        -bordermode ignore 
    place $w.lab80c \
        -in $w -x 410 -y 460 -width 110 -height 18 -anchor nw \
        -bordermode ignore 	    
    button $w.but46 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
	-highlightcolor black -text {Generate Chitin Structure}\
	    -command {set ::chitin::xv1 [expr $::chitin::avalue*$::chitin::xdim]; \
			  set ::chitin::yv1 [expr $::chitin::bv1*$::chitin::bvalue*$::chitin::ydim]; \
			  set ::chitin::yv2 [expr $::chitin::bv2*$::chitin::bvalue*$::chitin::ydim]; \
			   set ::chitin::zv3 [expr $::chitin::cvalue*$::chitin::zdim]; \
		       [namespace code {::chitin::replicate "$::chitin::xdim" "$::chitin::ydim" "$::chitin::zdim" "$::chitin::crystal" "$::chitin::perio"}]}

	    
    #vTcl:DefineAlias "$w.but46" "Button1" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab47 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify left -text {Chitin crystal allomorph:} 
    #vTcl:DefineAlias "$w.lab47" "Label1" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab48 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify left \
        -text {Number of replicas in x:} 
    #vTcl:DefineAlias "$w.lab48" "Label2" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab49 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify left \
        -text {Number of replicas in z:} 
    #vTcl:DefineAlias "$w.lab49" "Label2_1" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab50 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -justify left \
        -text {Number of replicas in y:} 
    #vTcl:DefineAlias "$w.lab50" "Label2_2" #vTcl:WidgetProc "Toplevel1" 1
    entry $w.ent51 \
        -background white -font {-family {DejaVu Sans Mono} -size 10} \
        -foreground {#000000} -highlightcolor black -insertbackground black \
	-selectbackground {#c4c4c4} -selectforeground black  \
	-textvariable ::chitin::xdim					
    #vTcl:DefineAlias "$w.ent51" "Entry1" #vTcl:WidgetProc "Toplevel1" 1
    entry $w.ent52 \
        -background white -font {-family {DejaVu Sans Mono} -size 10} \
        -foreground {#000000} -highlightcolor black -insertbackground black \
        -selectbackground {#c4c4c4} -selectforeground black \
	-textvariable ::chitin::ydim					
    #vTcl:DefineAlias "$w.ent52" "Entry2" #vTcl:WidgetProc "Toplevel1" 1
    entry $w.ent53 \
        -background white -font {-family {DejaVu Sans Mono} -size 10} \
        -foreground {#000000} -highlightcolor black -insertbackground black \
        -selectbackground {#c4c4c4} -selectforeground black \
	-textvariable ::chitin::zdim
    #vTcl:DefineAlias "$w.ent53" "Entry3" #vTcl:WidgetProc "Toplevel1" 1
    label $w.lab43 \
        -activebackground {#f9f9f9} -activeforeground black \
        -background {#d9d9d9} -font TkDefaultFont -foreground {#000000} \
        -highlightcolor black -text {Periodic bonds:} 
    #vTcl:DefineAlias "$w.lab43" "Label10" #vTcl:WidgetProc "Toplevel1" 1

    ###################
    # SETTING GEOMETRY
    ###################
    place $w.fra45 \
        -in $w -x 20 -y 70 -width 560 -relwidth 0 -height 120 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.but46 \
        -in $w -x 20 -y 320 -width 560 -relwidth 0 -height 38 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.lab47 \
        -in $w -x 110 -y 40 -width 166 -relwidth 0 -height 28 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.lab48 \
        -in $w -x 100 -y 200 -width 170 -relwidth 0 -anchor nw \
        -bordermode ignore 
    place $w.lab49 \
        -in $w -x 100 -y 260 -width 170 -relwidth 0 -height 18 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.lab50 \
        -in $w -x 100 -y 230 -width 170 -relwidth 0 -height 18 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.ent51 \
        -in $w -x 300 -y 200 -anchor nw -bordermode ignore 
    place $w.ent52 \
        -in $w -x 300 -y 230 -anchor nw -bordermode ignore 
    place $w.ent53 \
        -in $w -x 300 -y 260 -anchor nw -bordermode ignore 
    place $w.lab43 \
        -in $w -x 170 -y 290 -anchor nw -bordermode ignore 
    place $w.fra43 \
        -in $w -x -5 -y 0 -width 610 -relwidth 0 -height 30 -relheight 0 \
        -anchor nw -bordermode ignore 
    place $w.crystalpick \
         -in $w -x 290 -y 40 -width 165 -anchor nw -bordermode ignore 
    place $w.periopick \
         -in $w -x 290 -y 290 -width 165 -anchor nw -bordermode ignore 
}











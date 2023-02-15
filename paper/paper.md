---
title: 'Chitin Builder: a VMD tool for the generation of structures of chitin molecular crystals for atomistic simulations'
tags:
  - VMD
  - chitin polymer structure
  - molecular dynamics
  - tcl
authors:
  - name: David Malaspina
    orcid: 0000-0002-5420-9534
    affiliation: "1, 2 "
  - name: Jordi Faraudo
    orcid: 0000-0002-6315-4993
    corresponding: true # (This is how to denote the corresponding author)
    affiliation: 1
affiliations:
 - name: Institut de Ciencia de Materials de Barcelona (ICMAB-CSIC),Campus UAB Bellaterra, Barcelona, Spain
   index: 1
 - name: Fundacio Universitat Rovira i Virgili, Av. dels Paisos Catalans 18, 43007, Tarragona, Spain
   index: 2
date: 15 February 2023
bibliography: paper.bib
---

# Summary
Chitin is the second most abundant organic material in nature after cellulose and its study is now of great interest in the field of biocompatible and eco-friendly materials. 
Computational studies of natural polymers such as Cellulose and Chitin are often hindered by the practical difficulties in generating structures suitable for the simulations.
This has motivated the recent introduction of a cellulose builder tool that generates coordinate, structure and topology files for atomistic simulations of cellulose crystal polymorhs.
Here we present an analogous tool for Chitin, the Chitin Builder tool, a program that enhances the Visual Molecular Dynamics (VMD) environment with the ability to generate coordinate and structure files of chitin organic crystals.
The program generates cartesian coordinates and atomic connectivity and structure files for crystalline structures of chitin polymorphs $\alpha$ and $\beta$.
Crystal structures of any size with or without bonds in the periodic directions can be easily build.
The resulting structure is automatically saved in PDB and PSF format (used by well known simulation packages such as NAMD) and it can be easily converted to many other file formats using VMD build-in features.


# Introduction

\label{sec:Introduction}

Chitin is a polysaccharide present in the exoskeleton and internal structure of many invertebrates like molluscs, crustaceans, insects, fungus, algae, and other related organisms [@Dutta2002CHITINAPPLICATIONS; @Zargar2015AApplications].
It is so prevalent in nature that it constitutes the second most abundant polymerized form of carbon in Earth.
From the point of view of material sciences, chitin is biorenewable, environmentally friendly, biocompatible and biodegradable material.
It has applications as a chelating agent, water treatment additive, drug carrier, biodegradable pressure‐sensitive adhesive tape, wound‐healing agents and many others [@Zargar2015AApplications; @Shamshina2019AdvancesReview; @RaviKumar2000AApplications]. 

Chemically, chitin is a polysaccharide composed of repeated units of (1-4) N-acetyl-D-glucosamine (2-acetamido-2-deoxy-$\beta$-D-glucopyranose). 
As other polysaccharides such as cellulose, chitin is usually found in crystal structures with several inter-chain hydrogen bonds that produce high order structures. 
There are three known crystal allomorphs [@Jang2004PhysicochemicalResources]: $\alpha$, $\beta$ and $\gamma$ chitin.
The crystal structures of $\alpha$ and $\beta$ chitin (the most abundant allomorphs) are known [@Sikorski2009Revisit; @Nishiyama2011Xray] but the structure of the rare $\gamma$ chitin alomorph is still under debate [@Jang2004PhysicochemicalResources; @Kaya2017On-chitin; @Ramirez-Wong2016Sustainable-solvent-inducedFilms].

\begin{figure}[ht]
\includegraphics[width=0.9\columnwidth]{alpha-beta.png}
\caption{Structure of chitin crystal allomorphs $\alpha$ and $\beta$.   a) $\alpha$ chitin primitive unit cell. b) $\beta$ chitin expanded unit cell (corresponding to 2 primitive unit cells). c) scheme of the antiparallel organization of the chains in $\alpha$ chitin, indicated by arrows over a crystal generated with the input for the number of replicas $a$=1 $b$=2 $c$=3. d) scheme of the parallel chain organization in $\beta$ chitin, indicated by arrows over a crystal generated with the input for the number of replicas $a$=1 $b$=2 $c$=3 (note that an extra plane of molecules is below the image in this case). Chitin molecules are shown in bond representation in all cases (O in red, H in white, N in blue and H in white). Figure made with VMD.}
\label{fgr:crystals}
\end{figure}

The knowledge of the crystal structures of chitin with atomistic resolution is important from both a fundamental and practical point of view, since it opens the possibility to predict the properties of chitin based materials and derivatives (mechanical, thermal, interaction with solvents,...) from the knowledge of its molecular structure.
Starting from the atomic coordinates provided by crystal structures, it is possible to perform Molecular Dynamics (MD) simulations of chitin and study its properties and its interactions with other materials.
However, up to date, there are only a few works that deal with all-atomic MD simulations of chitin  [@Yu2017Flexibility; @McDonnell2016MolecularFilms; @Strelcova2016TheSimulations; @Jin2013MechanicalStudy].
These studies explore important practical questions such as the interaction of chitin with proteins or the mechanical properties of chitin.

The lack of atomistic simulations of chitin, is even more surprising when we compare this situation with the case of cellulose, which is the other most abundant polysaccharide. 
In the case of cellulose, there are many atomistic simulation works, deriving the most diverse features of cellulose from the known crystal structure [@Malaspina2019MolecularNanocrystals].
We think that one possible reason for this difference is the availability of a cellulose builder tool [@Gomes2012Cellulose-Builder:Cellulose] that allows an easy build up of atomistic configurations and structure/topology files that can be used for MD simulations.
Since these materials are complex materials, the build up of the files required for the simulations is not a trivial task. 
It is clear that the existence of tools that facilitate the build up of appropriate files for atomistic simulation of polymeric organic crystals will fuel the use of simulation techniques for the understanding of these important materials.

In this work we present a chitin builder tool implemented as a plugin of the Visual Molecular Dynamics (VMD) program [@Humphrey1996VMD:Dynamics]. The pugin produces files containing atomic coordinates and all the topology information of pure $\alpha$ and $\beta$ chitin crystals of arbitrary size.

This plugin will greatly facilitate the process of generation of input files (coordinates, structures, topology) for atomistic simulations and we expect that it will fuel the use of these techniques in the study of these materials. 
Future developments of these plugin will incorporate the generation of crystal structures of other polymeric crystals.

# Methods

\label{sec:Methods}
\subsection{Crystal structures of Chitin}

As we mentioned in the Introduction, there are three known chitin crystal allomorphs, $\alpha$, $\beta$ and $\gamma$ chitin.
However, we will not consider $\gamma$ chitin since its structure is not well known and in fact it is sometimes considered as a mixture of $\alpha$ and $\beta$ chitin [@Jang2004PhysicochemicalResources; @Kaya2017On-chitin; @Ramirez-Wong2016Sustainable-solvent-inducedFilms].
The crystal structures of $\alpha$ and $\beta$ chitin allomorphs are shown in Figure \ref{fgr:crystals}.
In the case of $\alpha$ chitin, we show in Figure \ref{fgr:crystals}a the primitive cell as determined by from X-ray diffraction in Ref. [@Sikorski2009Revisit].
This is the unit cell employed in our program for $\alpha$ chitin.
 Note that $\alpha$ chitin crystals have a characteristic antiparallel organization of chitin chains, as shown in Figure \ref{fgr:crystals}c. 
 
In the case of $\beta$ chitin, it is important to note that $\beta$ chitin is partially soluble in water and in fact interaction with water seems to modify the crystal structure [@Jang2004PhysicochemicalResources].
For this reason, we consider its anhydrous form, as determined by X-ray diffraction in Ref. [@Nishiyama2011Xray].
The structure of the anhydrous $\beta$ chitin allomorph is shown in Figure \ref{fgr:crystals}.
The unit cell of $\beta$ chitin employed in our program is the cell shown in Figure \ref{fgr:crystals}b.
This is an expanded cell, corresponding to double of the primitive cell in both the $a$ and $b$ directions, that facilitates the understanding of the structure and also simplifies the replication algorithm employed in our program.
This is due to the characteristic parallel organization of $\beta$ chitin chains in the crystal (see Figure \ref{fgr:crystals}d).
This organization of the extended crystal is more easily generated by simple replications of the unit cell shown in Figure \ref{fgr:crystals}b, without introducing any practical limitation in simulation studies.

An important feature determined in experiments is the presence of deacetylated groups (chitosan groups) in the fibril structure. This degree of deacetylation in chitin is of approximately between $5$ to 15$\%$ [@Zargar2015AApplications] although there are species that produce chitin of high purity.  
In our program, we will consider pure chitin so we do not consider the presence of deacetylated groups in the structures.
This possibility is too complex to be incorporated in our program at the present time until further modelling studies clarify a realistic way to incorporate this chemical feature.

\subsection{Generation of coordinates and topology of crystals}

The program generates atomic coordinates of $\alpha$ and $\beta$ chitin crystals with dimensions entered by the user.
The dimensions of the crystal must be a multiple of the unit cell shown in Figure \ref{fgr:crystals}a for $\alpha$ chitin and in Figure \ref{fgr:crystals}b for $\beta$ chitin crystals.
The atomic coordinates and cell vectors of the cells shown in Figures \ref{fgr:crystals}a and \ref{fgr:crystals}b were converted by us from the cif files containing X-ray crystallography data supplied in Refs.  [@Sikorski2009Revisit; @Nishiyama2011Xray] and are distributed with our program in PDB format in order to be understood by the VMD program.
These files are given in the folder $/structures$  (alpha-4residues.pdb and beta-4residues.pdb).
The user specifies how many replicas wants to obtain in each of the three main axis ($a$, $b$ and $c$) and the program (which is a TCL script running inside VMD) loads the required PDB file with the atomic coordinates of the unit cell and replicates the coordinates. 
 Once the coordinates are calculated, an intermediate file is generated containing the coordinates of the atoms in the new crystal cell in PDB format (crystal-alpha-temp.pdb or crystal-beta-temp.pdb).
These coordinate files can be used inside input files of certain calculations (for example, geometry optimizations or structural relaxations with DFT packages) but they do not contain enough information for  force-field based molecular dynamics (MD) simulation packages.
For these MD simulations, topology and structural information (such as atom type, atom connectivity, partial charges,...) is required.
In order to generate this additional information, we employ the topology from the carbohydrates section of CHARMM36 force field [@Guvench2011CHARMMModeling].
Chitin monomers correspond to the standard CHARMM36 residue BGLCNA (beta-N-acetyl-glucosamine).
But here, we modify the name of this residue to BGNA in order to have a 4 characters residue name which is the preferred residue name length for several simulation and analysis packages and it is also the residue length specified in the standard PDB format.
The corresponding topology file from CHARMM36 "top\_all36\_carb.rtf", modified with the new residue name, is included in the $/structures$ folder.
Our program automatically calls the 
psfgen package included in VMD to generate a new PDB coordinate file and a PSF structure file combo containing the same crystal coordinates generated before but now including the BGNA residue name, CHARMM36 atom types, charges, bonds, angles and dihedrals.   
In the generation of the structure PSF file, each chitin chain in the new crystal cell is treated as an individual segment. 
Each chitin residue in each chain is linked by the "14bb" patch in the topology file, that correspond to the (1-4)beta glycosidic bond.
 Finally, an additional bond between the first and last residue of the chain can be optionally included, by selection of the option "periodic bonds" by the user (see details of the user interface below).
 This possibility allows the simulation of infinitely long chains with the use of periodic boundary conditions.
 The generated pdb and psf files are finally saved into the working folder and are ready to be employed in force field MD simulations.
 For completeness, we also provide a parameters file ("par\_all36\_carb.prm" in the ForceField folder) with CHARMM36 carbohydrate standard Lennard-Jones, bonds, angles and dihedrals sections of the CHARMM36 force field needed for the simulation. 
 
# Program description, use and features

\subsection{Brief description of the program}

The code is a plugin for VMD written in tcl/tk v8.4 programming language.
The source code contains two main parts: the code that obtains the atomic coordinates of the atoms of the crystal and the structure and topology of the crystal (see Methods section) and a code responsible for the  graphical user interface (gui).
The program generates two main outputs: a coordinate file (PDB) containing the position of all the atoms in the generated structure and a topology file (PSF) containing all the bonds, angles and dihedrals according to CHARMM36 carbohydrate section [@Guvench2011CHARMMModeling].
These output files are named crystal-alpha-psf.pdb/psf or crystal-beta-psf.pdb/psf depending on the allomorph, and are stored in the working folder choosen by the user. 
This two files, plus the included CHARMM36 parameters file (located in the /ForceField/ folder) allows the user to easily start a molecular dynamics simulation using the NAMD simulation program [@Phillips2005ScalableNAMD] that accompanies VMD.
Also, using VMD, the users can easily export the data from these two files (PDB and PSF) to other coordinates formats or convert the topology to the formats required by other programs such as GROMACS [@VanDerSpoel2005GROMACS:Free, @Hess2008GROMACSSimulation] using the topotools plugin included in VMD. 

\subsection{Installation}

As we mentioned before the code is a plugin for VMD. 
In the Readme.md file we detailed the installation process.
Basically, the plugin can be easily installed by simply moving the downloaded plugin folder inside the standard plugin folder of VMD (the folder /plugins/noarch/tcl/ inside the folder where VMD is installed). 
Usually administrator privileges are needed to copy into the VMD installation folder.
Also note that the specific location at which VMD is installed vary depending on the operating system and the user VMD installation preferences, as explained in VMD documentation.
We also included a bash script that performs an automatic installation for Ubuntu Linux system.

\subsection{Graphical user interface}
%The gui code was partially created using PAGE: Python Automatic GUI Generator v4.22 by Don Rozenberg. 
All the options of our plugin are controlled from a graphical user interface (GUI), shown in figure \ref{fgr:guisections}.
This GUI allows the user to switch between the different options for the chitin crystal generation (Figure \ref{fgr:guisections}). 
It also provides a quick view to the unit cell data as well as the cell vectors describing the generated crystal, to be employed in a MD simulation.  

In Figure \ref{fgr:guisections}, we also indicate the different sections of the GUI which are the following:

Section 1) of the gui correspond to the "help" menu.
It contains two items: "About", that contains information of the developers and "Documentation", that redirects the user to the Bitbucket repository code webpage where a Readme.md file explains the main features of the code. 
Also, the last version of the code is available at this repository.

Section 2) of the gui corresponds to the selection of the crystal allomorph. 
It contains a button that allows the user to choose between $\alpha$ and $\beta$ chitin allomorphs as explained in the Method section.
Under this button a description of the unit cell data including $a$, $b$ and $c$ cell vectors and $\alpha$, $\beta$ and $\gamma$ angles is shown (corresponding to the unit cells in Figures \ref{fgr:crystals} a and c) as well as the reference to the primary publication where the experimental data (from which this unit cell was build) can be found.

Section 3) of the gui allows the user to input the number of replicas in $a$, $b$ and $c$ crystallographic directions of the new crystal that is going to be generated. 
The inputs need to be an integer and the maximum number that the calculation allow is such that the number of replicas do not exceed 9.999$\times 10^3$ residues (the maximum allowed by VMD). 
Under the input for the number of replicas, a button allows the user to select between a structure with ("yes") or without ("no") periodic bonds in the longitudinal direction of the polysaccharide chain.
This type of bonds allow the simulation of infinitely long molecular crystals by using periodic boundary conditions.
At the bottom of this section the button "Generate Chitin Structure" will prompt dialog box where the user need to choose the destination folder and after this the code will initialize for the replication and topology generation. 
Once the calculation is done the generated structure will appear in the VMD display and the output files crystal-alpha-psf.psf/pdb or crystal-beta-psf.psf/pdb will be generated on the destination folder selected by the user.
Data of the crystal cell will be printed on the gui, on the main console and in the log file "crystal.log".

Finally, section 4) of the gui displays the cell data of the generated chitin structure. The cell data is displayed as a matrix of the cell vector data(the employed units are \AA).
The first row correspond to the 3 cartesian components (i, j, k) of the $a$ vector of the cell, second row correspond to the 3 components of the $b$ vector of the cell and third row to the 3 components of the $c$ vector of the cell. 
This data is provided in this format so the user can use it directly in a  configuration file for a MD simulation (as in a simulation with NAMD for example).
This useful data is also printed on the main console and on the log file.

\begin{figure}[ht]
\includegraphics[width=0.9\columnwidth]{gui-screenshot-sections.png}
\caption{Chitin builder graphical user interface sections}
\label{fgr:guisections}
\end{figure}

# Examples

Using the chitin builder plugin we have generated several structures as is displayed in Figure \ref{fgr:examples}.
All the generated structures (PDB + PSF files) are included in the /examples/ folder as well as a screen capture of the gui that generated the respective structure.

In the first example (Figure \ref{fgr:examples}a), we have created an $\alpha$ chitin crystal with the input parameters for the replicas $a$=4, $b$=2 and $c$=4 and the option of periodic bonds was turn to "no".
In Figure \ref{fgr:examples}a we show the resulting crystal produced by the program. 
Using this input, the program produces a crystal cell of 19.0  \AA\ in the $a$ direction, 37.78 \AA\ in the $b$ direction and 41.33 \AA\ in the $c$ direction.
This structure is provided to the user in the folder /examples/example-a-alpha-4-2-4/.

In the second example (Figure \ref{fgr:examples}b) we created a $\beta$ chitin crystal with the input parameters for the replicas $a$=2, $b$=2 and $c$=4.
The option periodic bonds was also turn to "no". 
The crystal generated with these options is shown in Figure \ref{fgr:examples}b. 
It has a length of 19.276 \AA, a height of 36.956 \AA, and depth of 41.536 \AA. 
Note that this structure is equivalent to the $\alpha$ in Figure \ref{fgr:examples}a), but the number of replicas needed to generate it is different due to the differences in the unit cells \ref{fgr:crystals}. 
This structure is provided as an example to the user in the folder /examples/example-b-beta-2-2-4/.

\begin{figure}[ht]
\includegraphics[width=0.9\columnwidth]{examples.png}
\caption{Examples of crystal structures generated by chitin builder. a) $\alpha$ chitin crystal (input parameters $a$=4, $b$=2, $c$=4), x-y plane on the left and y-z plane on the right . b) $\beta$ chitin crystal (input parameters $a$=2, $b$=2, $c$=4), x-y plane on the left and y-z plane on the right. c) $\beta$ chitin crystal (input parameters $a$=2, $b$=2, $c$=4) with periodic bonds, y-z plane. d) $\beta$ chitin crystal (input parameters $a$=2, $b$=2, $c$=2) y-z plane. e) $\beta$ chitin crystal (input parameters $a$=4, $b$=2, $c$=4) x-y plane. f) $\beta$ chitin crystal (input parameters $a$=2, $b$=4, $c$=4) x-y plane. Chitin molecules are shown in bond representation in all cases (O in red, H in white, N in blue and H in white). Figure made with VMD. [@Humphrey1996VMD:Dynamics].}
\label{fgr:examples}
\end{figure}

In the third example (Figure \ref{fgr:examples}c) we repeated the creation of a $\beta$ chitin crystal with the input parameters for the replicas $a$=2, $b$=2 and $c$=4, but this time the periodic bond option was set to "yes". 
In Figure \ref{fgr:examples}c) we can observe the effect of setting the periodic bond option to "yes" bonds as a direct link between the first residue of chitin chain with the last residue. 
In a periodic boundary condition representation in VMD this would produce an infinitely long chitin chain, as seen in this figure, since it will link the chain with its periodic representation. 
This structure is located in the folder /examples/example-c-beta-2-2-4-periodic/.

In the fourth example (Figure \ref{fgr:examples}d) we created a $\beta$ chitin crystal with the input parameters for the replicas $a$=2, $b$=2 and $c$=2, resulting in a crystal with the following dimensions: 19.276 \AA\ length, 36.956 \AA\ height and a depth of 20.768\AA.
The option periodic bonds was turn to "no".
Note that this structure is half the size of the second example (Fig. \ref{fgr:examples}b) in the $c$ direction.
The files for this structure are located in the folder /examples/example-d-beta-2-2-2/.

In the fifth example (Figure \ref{fgr:examples}e) we created a $\beta$ chitin crystal with the input parameters for the replicas $a$=4, $b$=2 and $c$=4, resulting in a crystal with dimensions 38.552 \AA, 36.956 \AA\ and 41.536 \AA. 
The option periodic bonds was turn to "no". 
Note that this structure is twice the size of the second example (Fig. \ref{fgr:examples}b) in the $a$ direction.
The files for this structure are located in the folder /examples/example-e-beta-4-2-4/.

Finally in the sixth example (Figure \ref{fgr:examples}f)) we created a $\beta$ chitin crystal with the input parameters for the replicas $a$=2, $b$=4 and $c$=4 resulting in a crystal with dimensions 19.276 \AA, 36.956 \AA\ and 41.536 \AA. 
The option periodic bonds was turn to "no".
Note that this structure is twice the size of \ref{fgr:examples}b) in the $b$ direction.
This structure is located in the folder /examples/example-f-beta-2-4-4/.

# Compatibility and distribution
The chitin builder tool is written in tcl/tk as VMD plugin; it will therefore work on any of the platforms supported by the VMD program (Linux, OSX, Windows).
The latest version of the package can be obtained from the GitHub repository.
The repository includes installation instructions for different platforms.

# Acknowledgements

We acknowledge financial support from the Spanish Government through the   RTI2018-096273-B-I00 grant and the “Severo Ochoa” Grant SEV-2015-0496 for Research Centres of Excellence awarded to ICMAB. 
D.C. Malaspina is supported by the European Union's Horizon 2020 research and innovation programme under Marie Sklodowska-Curie grant agreement No 6655919. 
We acknowledge discussions with Prof. Lars A. Berglund and Dr Yamila Garcia about chitin materials. 

# References

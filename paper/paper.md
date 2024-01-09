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


# Statement of Need

Chitin is a polysaccharide present in the exoskeleton and internal structure of many invertebrates like molluscs, crustaceans, insects, fungus, algae, and other related organisms [@Dutta2002CHITINAPPLICATIONS; @Zargar2015AApplications].
It is so prevalent in nature that it constitutes the second most abundant polymerized form of carbon in Earth.
From the point of view of material sciences, chitin is biorenewable, environmentally friendly, biocompatible and biodegradable material.
It has applications as a chelating agent, water treatment additive, drug carrier, biodegradable pressure‐sensitive adhesive tape, wound‐healing agents and many others [@Zargar2015AApplications; @Shamshina2019AdvancesReview; @RaviKumar2000AApplications]. 

The posibility to generate atomic coordinates of the crystal structures of chitin is important from both a fundamental and practical point of view, since it opens the possibility to predict the properties of chitin based materials and derivatives (mechanical, thermal, interaction with solvents,...).
Starting from the atomic coordinates provided by crystal structures, it is possible to perform Molecular Dynamics (MD) simulations of chitin and study its properties and its interactions with other materials.
However, up to date, there are only a few works that deal with all-atomic MD simulations of chitin  [@Yu2017Flexibility; @McDonnell2016MolecularFilms; @Strelcova2016TheSimulations; @Jin2013MechanicalStudy].
These studies explore important practical questions such as the interaction of chitin with proteins or the mechanical properties of chitin.

The lack of atomistic simulations of chitin is even more surprising when we compare this situation with the case of cellulose, which is the other most abundant polysaccharide. 
In the case of cellulose, there are many atomistic simulation works, deriving the most diverse features of cellulose from the known crystal structure [@Malaspina2019MolecularNanocrystals].
We think that one possible reason for this difference is the availability of a cellulose builder tool [@Gomes2012Cellulose-Builder:Cellulose] that allows an easy build up of atomistic configurations and structure/topology files that can be used for MD simulations.
Since these materials are complex materials, the build up of the files required for the simulations is not a trivial task. 
It is clear that the existence of tools that facilitate the build up of appropriate files for atomistic simulation of polymeric organic crystals will fuel the use of simulation techniques for the understanding of these important materials.

In this work we present a chitin builder tool implemented as a plugin of the Visual Molecular Dynamics (VMD) program [@Humphrey1996VMD:Dynamics]. The pugin produces files in PDB and PSF format containing atomic coordinates and topology information of pure $\alpha$ and $\beta$ chitin crystals of arbitrary size.

This plugin will greatly facilitate the process of generation of input files (coordinates, structures, topology) for atomistic simulations and we expect that it will fuel the use of these techniques in the study of these materials. 
Future developments of these plugin will incorporate the generation of crystal structures of other polymeric crystals.
 
# Brief description of the Program use and features

The code is a plugin for VMD written in tcl/tk v8.4 programming language.
It an be executed from a graphical user interface (gui) or from the VMD Tk console command line.
The source code contains two main parts: the code that calculates the atomic coordinates of the atoms of the crystal and the structure and topology of the crystal and a code responsible for the  graphical user interface (gui).
The program generates two main outputs: a coordinate file (PDB) containing the position of all the atoms in the generated structure and a topology file (PSF) containing all the bonds, angles and dihedrals according to CHARMM36 carbohydrate section [@Guvench2011CHARMMModeling].
These output files are named crystal-alpha-psf.pdb/psf or crystal-beta-psf.pdb/psf depending on the allomorph, and are stored in the working folder choosen by the user. 
This two files, plus the included CHARMM36 parameters file (located in the /ForceField/ folder) allows the user to easily start a molecular dynamics simulation using the NAMD simulation program [@Phillips2005ScalableNAMD] that accompanies VMD.
Also, using VMD, the users can easily export the data from these two files (PDB and PSF) to other coordinates formats or convert the topology to the formats required by other programs such as GROMACS [@VanDerSpoel2005GROMACS:Free; @Hess2008GROMACSSimulation] using the topotools plugin included in VMD. 

Details on installation of the software, the user manual and examples of code use are provided in the GitHUb code repository.

# Acknowledgements

We acknowledge financial support from the Spanish Government through the RTI2018-096273-B-I00 grant and the “Severo Ochoa” Grant CEX2019-000917-S  for Research Centres of Excellence awarded to ICMAB. We also thank the Government of Catalonia (AGAUR) for grant 2021SGR01519. 
D.C. Malaspina was supported by the European Union's Horizon 2020 research and innovation programme under Marie Sklodowska-Curie grant agreement No 6655919. 
We acknowledge discussions with Prof. Lars A. Berglund and Dr Yamila Garcia about chitin materials. 

# References

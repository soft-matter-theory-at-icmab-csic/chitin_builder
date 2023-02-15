---
title: 'Chitin Builder: a VMD tool for the generation of structures of chitin molecular crystals for atomistic simulations'
tags:
  - VMD
  - tcl
  - Molecular Dynamics
  - Chitin polymer
authors:
- name: David C Malaspina
    orcid: 0000-0002-6315-4993
    affiliation: "1, 2" # (Multiple affiliations must be quoted)
- name: Jordi Faraudo
    orcid: 0000-0002-6315-4993
    corresponding: true # (This is how to denote the corresponding author)
    affiliation: 2
affiliations:
 - name: Tarragona, Spain
   index: 1
 - name: ICMAB-CSIC,Campus UAB Bellaterra, Barcelona, Spain
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

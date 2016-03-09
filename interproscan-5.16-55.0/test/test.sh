#!/bin/bash 

/scratch/projects/tacc/bio/interproscan/interproscan-5.8-49.0/interproscan.sh --formats tsv,gff3,xml --iprlookup --goterms --pathways --tempdir /tmp --output-dir . --input test/4K_Bos_taurus.UMD3.1.pep.all.fa 


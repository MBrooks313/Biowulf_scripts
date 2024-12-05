#######################################
# This Indexes.py Snakefile creates indexes necessary for STAR AND KALLISTO NGS analysis.
# Written by Matthew Brooks on Mar 30, 2017
# This runs on an HPC running SLURM
#######################################



#######################################
# Import config file and modules needed
#######################################

import config


#############################################################
# List of directories needed and end point files for analysis
#############################################################

#Import the species specific files from the config.py file
BASEDIR = config.BASEDIR
GENOME = config.GENOME
GTF = config.GTF
TRANS = config.TRANS
NAME = config.NAME

STAR_VER = config.STAR_VER
KALL_VER = config.KALL_VER

DIRS = ['STAR/', 'STAR/124base/', 'kallisto/', 'logs/']
STAR = BASEDIR + 'STAR/124base/' + 'SAindex'
STAR_NCBI = BASEDIR + 'STAR/124base/' + 'SAindex'
KAL = BASEDIR + 'kallisto/' + NAME



##############################
# Snakemake rules for analysis
##############################

localrules: dirs


rule all:
    input: DIRS, KAL, STAR#, STAR_NCBI
    threads: 1
    params: mem = "4G", time = "10:00:00"
    shell:  "mv *out logs/"

rule dirs:
    output: DIRS
    threads: 1
    params: mem = "4G", time = "01:00:00"
    shell:  "cd {BASEDIR}; mkdir -p "+' '.join(DIRS)

rule star:
    input: dir = 'STAR/124base/'
    output: STAR
    threads: 12
    params: mem = "96G", time = "04:00:00"
    shell: """
    cd {BASEDIR}
    module load STAR{STAR_VER} || exit 1
    STAR \
    --runThreadN {threads} \
    --runMode genomeGenerate \
    --genomeDir {input.dir} \
    --genomeFastaFiles {GENOME} \
    --sjdbGTFfile {GTF} \
    --sjdbOverhang 124 \
    --genomeSAindexNbases 11
    """

rule star_ncbi:
    input: dir = 'STAR/124base/'
    output: STAR
    threads: 12
    params: mem = "96G", time = "04:00:00"
    shell: """
    cd {BASEDIR}
    module load STAR/{STAR_VER} || exit 1
    STAR \
    --runThreadN {threads} \
    --runMode genomeGenerate \
    --genomeDir {input.dir} \
    --genomeFastaFiles {GENOME} \
    --sjdbGTFfile {GTF} \
    --sjdbGTFtagExonParentTranscript Parent \
    --sjdbOverhang 124 \
    --genomeSAindexNbases 11
    """

rule kallisto:
    input: dir = 'kallisto/'
    output: KAL
    threads: 1
    params: mem = "24G", time = "04:00:00"
    shell: """
    cd {BASEDIR}
    module load kallisto{KALL_VER} || exit 1
    kallisto index -i {input.dir}{NAME} {TRANS}
    """

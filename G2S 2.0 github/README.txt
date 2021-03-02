----------------------------------------------------------------------------------------------------------------------
                           				README
----------------------------------------------------------------------------------------------------------------------

SPACE REQUIREMENTS : g2s needs 32 GB of free space and 16 GB of RAM memory to work on your device

OTHER  REQUIREMENTS: 

- R > version 3.5.0
- keras for R
- tensorflow for R



FIRST STEPS

1) Download the g2s folder. 


2) R settings and keras/tensorflow initialization

R
install.packages("keras")
library(keras)

# Install tensorflow 
#It's only necessary to run this once. 

# for GPU
install_keras(tensorflow = "gpu")

# or CPU:
install_keras() 

quit()



USAGE AND HELP 

Rscript g2s.R otu_table_oral_microbiome.txt names_gingival_bacteria.txt model_21feb2021_g2s.hdf5 output_folder

- otu_table_oral_microbiome.txt: genus level (L6) relative abundance table with samples in the columns and the full taxonomy following the greengens 05_2013 style in the rows. Rel. Ab. must be 0 to 1. (INPUT)
- names_gengival_bacteria.txt: this file is provided together with the g2s script and is necessary for automatically formatting the input file.
- model_21feb2021_g2s.hdf5: this is the deep neural network implemented for doing the prediction
- output_folder: name of the output directory



EXPECTED OUTPUTS

The tool provides two files within the output folder. 
1 - (.txt) Tabular outputs report the predicted structure of the stool microbiome in term of relative abundances. 
2 - (.svg) Graphical representations (bar plots) of the predicted microbiome structures


EXAMPLES
For verifing the correct installation use the data within the test folder and compare the results you obtain with the files test_g2s.txt and test_g2s.pdf

Rscript g2s.R test/test.txt names_gingival_bacteria.txt model_21feb2021_g2s.hdf5 test_results


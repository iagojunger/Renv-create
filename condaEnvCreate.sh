#!/bin/bash


# 0.1 At this array, select all the packages you pretend to use. 
# FAQ: Don't know the package name in the conda database? (e.g., minfi)
#      Use the following command:
#      conda search minfi
# Note: You can also search on Google :)



conda_packages=(
    "r-base=4.1.3"
    "r-essentials"
    "r-devtools"
    "bioconductor-enmix"
    "bioconductor-minfi"
    "bioconductor-watermelon"
    "bioconductor-geoquery"
    "bioconductor-illuminahumanmethylationepicanno.ilm10b2.hg19"
    "bioconductor-illuminahumanmethylationepicanno.ilm10b4.hg19"
    "bioconductor-illuminahumanmethylationepicmanifest"
    "bioconductor-illuminaio"
    "r-svd"
    "r-r.utils"
    "nb_conda_kernels"
    "pip"
    "git"
)


# 0.2 Checking if the Environment already exists
#-------------------------------
#Dissecting the command:
# If the environment you're trying to create already exists (in this case, EWAS_env),
# the command will notify you that the environment exists. It will then intentionally
# delete the existing environment and recreate it. If the environment does not exist,
# the command will skip this step.

# Iago's notes: I designed it this way to ensure the environment is recreated with the
# updated conda_packages list, in case you need to update it
#-------------------------------

if conda env list | grep -qw 'EWAS_env'; then
  echo "------------------------------"
  echo "Environment 'EWAS_env' exists."
  echo "------------------------------"
  echo "Removing environment ... "
  conda env remove -n EWAS_env
  echo "------------------------------"
  echo "Environment removed." 
  echo "------------------------------"

else
  echo "Environment 'EWAS_env' does not exist. It will be created."
fi

conda init



# 1. Building base conda command 
#-------------------------------
# Dissecting the command:
#	conda create : Base command for creating environments in CLI conda.

#	-n  EWAS_env: The "-n" is the option to give the environment a name. 
#                     In this case, the name will be "EWAS_env"

#	-c conda-forge & -c bioconda: Adding the forge and bioconda database
#		      to the environment
#-------------------------------
conda_create_command="conda create -n EWAS_env -c conda-forge -c bioconda"

# 2. Adding the list of packages "conda_packages" to the command.
for package in "${conda_packages[@]}"; do
    conda_create_command+=" $package"
done

# 3. Checking and running.
echo "Running command: $conda_create_command"
eval $conda_create_command

# 4. Exporting the env to a .yml file
# 	- This way you can release your environment to other people who 
#	  want to run your pipeline.
conda env export -n EWAS_env > EpigeneticTrainin-QC-environment_R4.1.3.yml

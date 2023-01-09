#!/bin/bash

## Download_Source_Code.sh
## Part of CompileFlightGearDebian
##
## Author: Megaf - https://github.com/Megaf/
## Date: 09/01/2023
## Description: Script to download PLIB, OSB, SG and FG.

base_dir="$HOME"
install_dir="$base_dir/FlightGear"
source_dir="$base_dir/FlightGear_SourceCode"
data_dir="$base_dir/FlightGear_Data"
#flightgear_git="https://gitlab.com/flightgear/"
flightgear_git="https://git.code.sf.net/p/flightgear/"
flightgear_branch="next"
#flightgear_branch="release/2020.3"
#flightgear_branch="version/2020.3.17"
osg_branch="OpenSceneGraph-3.6"
#osg_branch="master"
download_jobs="16"

echo "CREATING DIRECTORIES"
mkdir -p "$install_dir" "$source_dir" "$data_dir"

echo "DOWNLOADING PLIB"
if [ ! -d "$source_dir/PLIB" ]
then
    git clone -b master -j "$download_jobs" https://github.com/Megaf/plib.git "$source_dir/PLIB"
else
    cd "$source_dir/PLIB" || exit
    git pull -j "$download_jobs"
fi

echo "DOWNLOADING OPENSCENEGRAPH"
if [ ! -d "$source_dir/OpenSceneGraph" ]
then
    git clone -b "$osg_branch" -j "$download_jobs" https://github.com/openscenegraph/OpenSceneGraph.git "$source_dir/OpenSceneGraph"
else
    cd "$source_dir/OpenSceneGraph" || exit
    git checkout "$osg_branch"
    git pull -j "$download_jobs"
fi

echo "DOWNLOADING SIMGEAR"
if [ ! -d "$source_dir/SimGear" ]
then
    git clone -b "$flightgear_branch" -j "$download_jobs" "$flightgear_git/simgear.git" "$source_dir/SimGear"
else
    cd "$source_dir/SimGear" || exit
    git checkout "$flightgear_branch"
    git pull -j "$download_jobs"
fi

echo "DOWNLOADING FLIGHTGEAR"
if [ ! -d "$source_dir/FlightGear" ]
then
    git clone -b "$flightgear_branch" -j "$download_jobs" "$flightgear_git/flightgear.git" "$source_dir/FlightGear"
else
    cd "$source_dir/FlightGear" || exit
    git checkout "$flightgear_branch"
    git pull -j "$download_jobs"
fi

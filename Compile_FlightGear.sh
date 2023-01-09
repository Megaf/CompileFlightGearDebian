#!/bin/bash

## Download_Source_Code.sh
## Part of CompileFlightGearDebian
##
## Author: Megaf - https://github.com/Megaf/
## Date: 09/01/2023
## Description: Script to compile PLIB, OSB, SG and FG.

unset CC
unset CXX
unset CMAKE_C_COMPILER
unset CMAKE_CXX_COMPILER
unset CFLAGS
unset CXXFLAGS
unset CMAKE_C_FLAGS
unset CMAKE_CXX_FLAGS

export PATH=/usr/lib/ccache:$PATH
#export CC="/usr/bin/gcc-10"
#export CXX="/usr/bin/g++-10"
#export CMAKE_C_COMPILER="gcc-10"
#export CMAKE_CXX_COMPILER="g++"
#export CFLAGS="-march=native -mtune=native -mfpmath=both -O3 -mfloat-abi=hard -pipe"
export CFLAGS="-march=native -mtune=native -O3 -pipe"
export CXXFLAGS="${CFLAGS}"
export CMAKE_C_FLAGS="${CFLAGS}"
export CMAKE_CXX_FLAGS="${CFLAGS}"

base_dir="$HOME"
install_dir="$base_dir/FlightGear"
source_dir="$base_dir/FlightGear_SourceCode"
build_dir="/tmp"
compile_jobs="$(nproc)"

echo "COMPILING PLIB"
cd "$source_dir/PLIB" || exit
./autogen.sh
./configure --prefix="$install_dir"
make -j "$compile_jobs"
make install

cd "$build_dir" || exit
rm -rf OpenSceneGraph SimGear FlightGear
mkdir -p OpenSceneGraph SimGear FlightGear

echo "COMPILING OPENSCENEGRAPH"
cd "$build_dir/OpenSceneGraph" || exit
cmake "$source_dir/OpenSceneGraph" -DCMAKE_C_FLAGS="${CFLAGS}" -DCMAKE_CXX_FLAGS="${CFLAGS}" -DCMAKE_INSTALL_PREFIX="$install_dir" -DCMAKE_BUILD_TYPE="Release" -DBUILD_OSG_DEPRECATED_SERIALIZERS=OFF -DBUILD_OSG_EXAMPLES=OFF -DBUILD_OSG_PACKAGES=OFF || exit
make -j "$compile_jobs"
make install

echo "COMPILING SIMGEAR"
cd "$build_dir/SimGear" || exit
cmake "$source_dir/SimGear" -DCMAKE_C_FLAGS="${CFLAGS}" -DCMAKE_CXX_FLAGS="${CFLAGS}" -DCMAKE_INSTALL_PREFIX="$install_dir" -DCMAKE_BUILD_TYPE="Release" -DENABLE_OPENMP=ON -DENABLE_SIMD_CODE=ON -DENABLE_TESTS=OFF || exit
make -j "$compile_jobs"
make install

echo "COMPILING FLIGHTGEAR"
cd "$build_dir/FlightGear" || exit
cmake "$source_dir/FlightGear" -DCMAKE_C_FLAGS="${CFLAGS}" -DCMAKE_CXX_FLAGS="${CFLAGS}" -DCMAKE_INSTALL_PREFIX="$install_dir" -DCMAKE_BUILD_TYPE="Release" -DFG_BUILD_TYPE=Release || exit
make -j "$compile_jobs"
make install

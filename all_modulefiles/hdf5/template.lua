conflict("hdf5")

help(
"The hdf5 module file defines the following environment variables:\n"..
"HDF5_DIR, HDF5_LIB, and HDF5_INC for the location of the \n"..
"HDF5 distribution.\n\n"..
"To use the HDF5 library, compile the source code with the option:\n"..
"-I$HDF5_INC \n"..
"and add the following options to the link step: \n"..
"-L$HDF5_LIB -lhdf5\n"..
"Version "..version..", compiled with "..compiler.." "..compiler_version.." compilers."
)

whatis( "Name: GNU Scientific Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library" )
whatis( "URL: http://www.gnu.org/software/hdf5/" )

local hdf5_base = "/Users/damon/ossw/libraries/hdf5/hdf5-"..version.."/"..compiler.."-"..compiler_version

if isDir(hdf5_base) then
else LmodError("module reports "..hdf5_base.." is not a directory! Module not loaded.")
end

prepend_path( "DYLD_LIBRARY_PATH", pathJoin(hdf5_base, "lib") )
prepend_path( "PATH", pathJoin(hdf5_base, "bin" ) )
prepend_path( "INCLUDE", pathJoin(hdf5_base, "include" ) )

setenv( "HDF5_DIR", hdf5_base )
setenv( "HDF5_BIN", pathJoin(hdf5_base, "bin" ) )
setenv( "HDF5_INC", pathJoin(hdf5_base, "include" ) )
setenv( "HDF5_LIB", pathJoin(hdf5_base, "lib" ) )

setenv( "HDF5_VERSION", version )

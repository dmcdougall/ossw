-- Instead of trying to list all possible MPI conflicts
-- we just tell it "mpi" family and it will error if any
-- other mpi family is loaded already
family("mpi")

help(
"MPICH MPI-3 Library\n"..
"Adds MPICH "..version.." built with "..compiler.." "..compiler_version.." compilers to environment.\n"..
"Adds lib directory to DYLD_LIBRARY_PATH\n"..
"Adds bin directory to PATH\n"..
"Adds man directory to MANPATH\n"
)

whatis( "Name: MPICH MPI-3 Library" )
whatis( "Version: "..version..", built with "..compiler.." "..compiler_version )
whatis( "Category: library, runtime support" )
whatis( "URL: http://www.mpich.org/" )

local mpi_base = "/Users/damon/ossw/libraries/mpich/mpich-"..version.."/"..compiler.."-"..compiler_version

if isDir(mpi_base) then
else LmodError("module reports "..mpi_base.." is not a directory! Module not loaded.")
end

local mod_path = "/Users/damon/ossw/derived_modulefiles/"..compiler.."/"..compiler_version.."/mpich/"..version.."/modulefiles"

prepend_path( "MODULEPATH", mod_path )

prepend_path( "DYLD_LIBRARY_PATH", pathJoin(mpi_base, "lib") )
prepend_path( "PATH", pathJoin(mpi_base, "bin" ) )
prepend_path( "MANPATH", pathJoin(mpi_base, "share/man" ) )
setenv( "MPI_DIR", mpi_base )

setenv( "MPICH_VERSION", version )
setenv( "MPI_IMPLEMENTATION", "mpich" )
setenv( "MPI_VERSION", version )

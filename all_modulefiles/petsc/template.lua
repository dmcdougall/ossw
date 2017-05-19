
prereq("openblas")

help(
"This module loads PETSc "..version.." compiled with "..compiler.." "..compiler_version
)

local petsc_dir = "/Users/damon/ossw/libraries/petsc/petsc-"..version
local petsc_arch =  compiler.."-"..compiler_version.."-"..mpi_implementation.."-"..mpi_version.."-"..petsc_type

if isDir(petsc_dir.."/"..petsc_arch) then
else LmodError("module reports "..petsc_dir.."/"..petsc_arch.." is not a directory! Module not loaded.")
end

setenv( "PETSC_DIR", petsc_dir )
setenv( "PETSC_ARCH", petsc_arch )
setenv( "PETSC_VERSION", version )

prepend_path( "DYLD_LIBRARY_PATH",  petsc_dir.."/"..petsc_arch.."/lib" )

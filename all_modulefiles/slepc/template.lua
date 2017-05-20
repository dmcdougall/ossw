
prereq("openblas", "petsc")

help(
"This module loads SLEPc "..version.." compiled with "..compiler.." "..compiler_version
)

local slepc_dir = "/Users/damon/ossw/libraries/slepc/slepc-"..version

if isDir(slepc_dir.."/"..petsc_arch) then
else LmodError("module reports "..slepc_dir.."/"..petsc_arch.." is not a directory! Module not loaded.")
end

setenv( "SLEPC_DIR", slepc_dir )
setenv( "SLEPC_VERSION", version )

prepend_path( "DYLD_LIBRARY_PATH",  slepc_dir.."/"..petsc_arch.."/lib" )


prereq( "petsc" )
conflict( "libmesh" )

local methods = "dbg"

help(
"This module loads libmesh "..version.." compiled with "..compiler.." "..compiler_version
)

local libmesh_dir = "/Users/damon/ossw/libraries/libmesh/libmesh-"..version
local arch =  compiler.."-"..compiler_version

if isDir(libmesh_dir.."/"..arch) then
else LmodError("module reports "..libmesh_dir.."/"..arch.." is not a directory! Module not loaded.")
end

setenv( "LIBMESH_DIR", libmesh_dir )
setenv( "LIBMESH_VERSION", version )
setenv( "METHODS", methods )

prepend_path( "DYLD_LIBRARY_PATH",  libmesh_dir.."/"..arch.."/lib" )

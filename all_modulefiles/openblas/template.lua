family("blas")

local openblas_dir = "/Users/damon/ossw/libraries/openblas/openblas-"..version.."/"..compiler.."-"..compiler_version

help(
"OpenBLAS BLAS Library\n"..
"Adds OpenBLAS "..version.." built with "..compiler.." "..compiler_version.." compilers to environment.\n"..
"Adds lib directory to LD_LIBRARY_PATH\n"..
"Adds bin directory to PATH\n"..
"Adds man directory to MANPATH\n"
)

whatis("Name: OpenBLAS BLAS Library")
whatis("Version: "..version..", built with "..compiler.." "..compiler_version)
whatis("Category: library, runtime support")
whatis("URL: http://xianyi.github.com/OpenBLAS/")

if isDir(openblas_dir) then
else LmodError("module reports "..openblas_dir.." is not a directory! Module not loaded.")
end

prepend_path("DYLD_LIBRARY_PATH", pathJoin(openblas_dir,"lib"))

setenv("OPENBLAS_DIR", openblas_dir)
setenv("OPENBLAS_LIB", pathJoin(openblas_dir, "lib"))

setenv("BLAS_IMPLEMENTATION", "openblas")
setenv("BLAS_VERSION", version)

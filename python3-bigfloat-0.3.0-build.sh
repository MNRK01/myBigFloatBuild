# Building GMP - disable Antivirus at the `make install` step since the Antivirus interferes with ranlib
# which modifies libgmp.a in place and that is a big no-no for an Antivirus. Viruses modify files in
# place with malicious code. Don't enable shared libraries since they create dll dependencies for the
# Python *.pyd extension. One can run the configure, make and make check steps in one step via
# `./configure ... && make && make check`
# GMP will be installed in /c/Software/MultiPrecLibs
cd /c/Software/gmp-6.1.2-src/
./configure --enable-static --disable-shared --prefix=/c/Software/MultiPrecLibs
make
make check
make install
make clean
cd ..
rm -rf gmp-6.1.2-src/

# Building MPFR - disable Antivirus at the make install step since the Antivirus interferes with ranlib
# which modifies libmpfr.a in place (see above). Don't enable shared libraries since they create
# dll dependencies for the Python *.pyd extension. One can run the configure, make and make check
# steps in one step via `./configure ... && make && make check`. Don't use -D__USE_MINGW_ANSI_STDIO=1
# since it does not fix the scientific notation prints test failures, e.g. 1.25000E+000 instead of 
# 1.25000E+00.
# MPFR will be installed in /c/Software/MultiPrecLibs
cd /c/Software/mpfr-4.0.1-src/
# ./configure --prefix=/c/Software/MultiPrecLibs --enable-static --enable-shared --with-gmp=/c/Software/MultiPrecLibs CFLAGS='-D__USE_MINGW_ANSI_STDIO=1' LDFLAGS='-static'
./configure --prefix=/c/Software/MultiPrecLibs --enable-static --disable-shared --with-gmp=/c/Software/MultiPrecLibs
make
make check
make install
make clean
cd ..
rm -rf mpfr-4.0.1-src/

# Building bigfloat
# https://wiki.python.org/moin/WindowsCompilers#GCC_-_MinGW-w64_.28x86.2C_x64.29
# https://pythonhosted.org/bigfloat/#installation
# https://docs.python.org/3/extending/building.html
# https://stackoverflow.com/questions/26059111/build-a-wheel-egg-and-all-dependencies-for-a-python-project
# Step  1) Unpack bigfloat-0.3.0 on the Desktop
# Step  2) Don't edit C:\Software\Anaconda3\Lib\distutils\distutils.cfg to include the following lines:
           # [build]
           # compiler=mingw32

           # [build_ext]
           # compiler=mingw32
           # >>> Note that this can mess up future VC builds so rename the file when you are done. <<<
           # >>> Otherwise use `python setup.py build --compiler=minge32` <<<
# Step  3) Edit C:\Software\Anaconda3\Lib\distutils\cygwinccompiler.py to replace the msvcr140 line
           # with vcruntime140 and also add the -static option to use static libgcc libraries:
           # 84       return ['msvcr100']
           # 85   elif int(msc_ver) >= 1900:
           # 86       # VS2015 / MSVC 14.0
           # 87       # return ['msvcr140'] RK, 10/28/2018
           # 88       return ['vcruntime140']
           # AND
           # 288          # ld_version >= "2.13" support -shared so use it instead of
           # 290          # -mdll -static
           # 291          if self.ld_version >= "2.13":
           # 292              # shared_option = "-shared" RK, 10/28/2018
           # 293              shared_option = "-shared -static"
           # 294          else:
           # 295              shared_option = "-mdll -static"
           # AND
           #                      ms_win=' -DMS_WIN64'
           #       self.set_executables(compiler='gcc -O2 -Wall'+ms_win,
           #                            compiler_so='gcc -mdll -O2 -Wall'+ms_win,
           #                            compiler_cxx='g++ -O2 -Wall'+ms_win,
           #                            linker_exe='gcc',
# Step  4) Use mintty\mingw64's gendef and dlltool to create import libraries for python36.dll and vcruntime140.dll:
           cd /c/Software/Anaconda3
           gendef python37.dll
           dlltool --dllname python37.dll --input-def python37.def --output-lib libpython37.a
           gendef vcruntime140.dll
           dlltool --dllname vcruntime140.dll --input-def vcruntime140.def --output-lib libvcruntime140.a
           mv *.a *.def ./libs
           ls ./libs
# Step  5) Back in the Windows command prompt, cd into bigfloat-0.3.0 and run `anaconda35env.bat --noupdate`
# Step  6) Tell python where to find the gcc, GMP and MPFR libraries:
           PATH=C:\Software\msys64\mingw64\bin;%PATH%
           set LIBRARY_PATH=C:\Software\MultiPrecLibs\lib
           set CPATH=C:\Software\MultiPrecLibs\include
# Step  7) Run `python setup.py build --compiler=mingw32` to build the C-extension library for bigfloat
# Step  8) Run to build a bigfloat wheel!!
           `pip wheel .`
           # OR run to build an sdist of bigfloat (which still needs C extension compilation)
           `python setup.py sdist`
           # OR run to install bigfloat on the build machine
           `python setup.py install`



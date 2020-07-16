# supercell-examples

Google Colaboratory
-

## Install (supercell)


	!apt update
	!apt install -y git wget openbabel
	%cd /content
	!git clone https://github.com/orex/supercell.git
	%cd supercell
	!wget https://orex.github.io/supercell/exe/supercell-linux.tar.gz
	!tar zxvf supercell-linux.tar.gz


## Install (cif2cell-informal)


	!apt update
	!apt install -y git python python-setuptools python-dev
	%cd /content
	!git clone https://github.com/by-student-2017/cif2cell-informal.git
	%cd cif2cell-informal
	!tar zxvf PyCifRW-3.3.tar.gz
	%cd PyCifRW-3.3
	!python2 setup.py install
	%cd /content/cif2cell-informal
	!python2 setup.py install


## Install (lammps)


	!wget https://lammps.sandia.gov/tars/lammps-stable.tar.gz
	!tar zxvf lammps-stable.tar.gz
	%cd lammps-3Mar20
	!mkdir build
	%cd build 
	!cmake -D BUILD_MPI=on -D PKG_USER-MEAMC=on -D PKG_MANYBODY=on -D PKG_MC=on ../cmake
	!cmake --build .


## Examples (FeCrW, lammps)


	%cd /content
	!git clone https://github.com/by-student-2017/supercell-examples.git
	!cp -r /content/supercell-examples/* /content/supercell/data/examples
	%cd /content/supercell/data/examples/FeCrW-SQS-OPT-gc
	!chmod +x df_cfg_lmp_gc.bash
	import os
	os.environ["OMP_NUM_THREADS"] = "1,1"
	os.environ["MKL_NUM_THREADS"] = "1"
	!./df_cfg_lmp_gc.bash 1x1x2 FeCrW.cif
	!cat SQS-1x1x2


## Install (PWscf)


	!apt update
	!apt install -y gcc g++ build-essential gfortran libopenblas-dev libfftw3-dev libopenmpi-dev wget
	%cd /content
	!wget https://github.com/QEF/q-e/archive/qe-6.4.1.tar.gz
	!tar zxvf qe-6.4.1.tar.gz
	%cd q-e-qe-6.4.1
	!wget https://github.com/QEF/q-e/releases/download/qe-6.4.1/backports-6.4.1.diff
	!patch -p1 --merge < backports-6.4.1.diff
	!./configure
	!make pw
	import os
	os.environ['PATH'] = "/content/q-e-qe-6.4.1/bin:"+os.environ['PATH']


## Examples (PbSnTe, PWscf)


	!apt update
	!apt install -y git
	%cd /content
	!git clone https://github.com/by-student-2017/supercell-examples.git
	%cp -r /content/supercell-examples/* /content/supercell/data/examples
	!cd /content/supercell/data/examples/PbSnTe-SQS-OPT-gc
	!chmod +x MSDA.bash
	!chmod +x df_cfg_qe_gc.bash
	import os
	os.environ["OMP_NUM_THREADS"] = "1,1"
	os.environ["MKL_NUM_THREADS"] = "1"
	!./df_cfg_qe_gc.bash 1x1x2 PbSnTe2.cif
	!cat SQS-1x1x2
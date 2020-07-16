# supercell-examples


## Install (supercell)
0. sudo apt update
  sudo apt install -y git wget openbabel
  cd ~
1. git clone https://github.com/orex/supercell.git
2. cd supercell
3. wget https://orex.github.io/supercell/exe/supercell-linux.tar.gz
4. tar zxvf supercell-linux.tar.gz

## Environment settings (supercell)
1. echo ' ' >> ~/.bashrc
  echo '# supercell environment settings' >> ~/.bashrc
  echo 'export PATH=$PATH:$HOME/supercell' >> ~/.bashrc
  echo 'export BABEL_DATADIR=$HOME/supercell' >> ~/.bashrc
2. bash

## Install (lammps)
1. wget https://lammps.sandia.gov/tars/lammps-stable.tar.gz
2. tar zxvf lammps-stable.tar.gz
3. cd lammps-3Mar20
4. mkdir build ; cd build 
5. cmake -D BUILD_MPI=on -D PKG_USER-MEAMC=on -D PKG_MANYBODY=on -D PKG_MC=on ../cmake
6. cmake --build .


## Environment settings (lammps)
1. echo 'export PATH=$PATH:$HOME/lammps-3Mar20/build'


## Examples (FeCrW)
0. cd ~
1. git clone https://github.com/by-student-2017/supercell-examples.git
2. cp -r ~/supercell-examples/* ~/supercell/data/examples
3. cd ~/supercell/data/examples/FeCrW-SQS-OPT
4. chmod +x df_cfg_lmp.bash
5. ./df_cfg_lmp.bash 1x1x2
  (or ./df_cfg_lmp.bash 2x2x1, etc)
6. cat SQS-1x1x2
  (or cat SQS-2x2x1, etc)
7. cat result.txt
(you can get Total energy [eV] for every *.cif)
(FeCrW-SQS-OPT is minimize version)


## Install (PWscf)
1. sudo apt update
  sudo apt install -y gcc g++ build-essential gfortran libopenblas-dev libfftw3-dev libopenmpi-dev wget
  cd ~
2. wget https://github.com/QEF/q-e/archive/qe-6.4.1.tar.gz
3. tar zxvf qe-6.4.1.tar.gz
4. cd q-e-qe-6.4.1
5. wget https://github.com/QEF/q-e/releases/download/qe-6.4.1/backports-6.4.1.diff
6. patch -p1 --merge < backports-6.4.1.diff
7. ./configure
8. make pw
9. sudo make install


## Examples (PbSnTe) (PWscf)
0. sudo apt update
  sudo apt install -y git
  cd ~
1. git clone https://github.com/by-student-2017/supercell-examples.git
2. cp -r ~/supercell-examples/* ~/supercell/data/examples
3. cd ~/supercell/data/examples/PbSnTe-SQS-OPT
4. chmod +x df_cfg_qe.bash
5. export OMP_NUM_THREADS=1
6. ./df_cfg_qe.bash 1x1x2 4
  (last number is number of cpus)
7. cat SQS-1x1x2


# Google Colaboratory
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
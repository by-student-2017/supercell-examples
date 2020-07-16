# supercell-examples


# Ubuntu 18.04 LTS or Debian 10.0


## Install (supercell)
1. cd ~
2. sudo apt update
3. sudo apt install -y git wget openbabel
4. git clone https://github.com/orex/supercell.git
5. cd supercell
6. wget https://orex.github.io/supercell/exe/supercell-linux.tar.gz
7. tar zxvf supercell-linux.tar.gz


## Environment settings (supercell)
1. echo ' ' >> ~/.bashrc
2. echo '# supercell environment settings' >> ~/.bashrc
3. echo 'export PATH=$PATH:$HOME/supercell' >> ~/.bashrc
4. echo 'export BABEL_DATADIR=$HOME/supercell' >> ~/.bashrc
5. bash


## Install (lammps)
1. cd ~
2. sudo apt update
3. sudo apt install -y gcc g++ build-essential gfortran libopenblas-dev libfftw3-dev libopenmpi-dev wget
4. wget https://lammps.sandia.gov/tars/lammps-stable.tar.gz
5. tar zxvf lammps-stable.tar.gz
6. cd lammps-3Mar20
7. mkdir build ; cd build 
8. cmake -D BUILD_MPI=on -D PKG_USER-MEAMC=on -D PKG_MANYBODY=on -D PKG_MC=on ../cmake
9. cmake --build .


## Environment settings (lammps)
1. echo ' ' >> ~/.bashrc
2. echo '# lammps environment settings' >> ~/.bashrc
3. echo 'export PATH=$PATH:$HOME/lammps-3Mar20/build' >> ~/.bashrc
4. bash


## Examples (FeCrW)
1. cd ~
2. git clone https://github.com/by-student-2017/supercell-examples.git
3. cp -r ~/supercell-examples/* ~/supercell/data/examples
4. cd ~/supercell/data/examples/FeCrW-SQS-OPT
5. chmod +x df_cfg_lmp.bash
6. ./df_cfg_lmp.bash 1x1x2
7. cat SQS-1x1x2
8. cat result.txt


## Install (PWscf)
1. cd ~
2. sudo apt update
3. sudo apt install -y gcc g++ build-essential gfortran libopenblas-dev libfftw3-dev libopenmpi-dev wget
4. wget https://github.com/QEF/q-e/archive/qe-6.4.1.tar.gz
5. tar zxvf qe-6.4.1.tar.gz
6. cd q-e-qe-6.4.1
7. wget https://github.com/QEF/q-e/releases/download/qe-6.4.1/backports-6.4.1.diff
8. patch -p1 --merge < backports-6.4.1.diff
9. ./configure
10. make pw
11. sudo make install


## Examples (PbSnTe) (PWscf)
1. cd ~
2. sudo apt update
3. sudo apt install -y git
4. git clone https://github.com/by-student-2017/supercell-examples.git
5. cp -r ~/supercell-examples/* ~/supercell/data/examples
6. cd ~/supercell/data/examples/PbSnTe-SQS-OPT
7. chmod +x df_cfg_qe.bash
8. export OMP_NUM_THREADS=1
9. ./df_cfg_qe.bash 1x1x2 4
10. cat SQS-1x1x2


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
	!apt update
	!apt install -y gcc g++ build-essential gfortran libopenblas-dev libfftw3-dev libopenmpi-dev wget
	%cd /content
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
#!/bin/bash

cif_name=`basename *.cif .cif`
cur_path=$PWD

if [[ -z "$PRG_lammps" ]]; then
  PRG_lammps="lammps"
fi

#cells=( 1x1x2 1x2x2 )
cells=( $1 )
latuni=( 0.94 0.97 1.00 1.03 1.06 )

for i in "${cells[@]}"
do
  rm -rf cell_$i
  mkdir cell_$i
  supercell -i ${cif_name}.cif -s $i -m -v 2 -o cell_$i/${cif_name}_c${i} > cell_$i/cell_${i}.out 2>&1  &
done

wait

for i in "${cells[@]}"
do
  cd ${cur_path}
  sqsf="${cur_path}/SQS-$i"
  echo -ne "cfg" > $sqsf
  for k in "${latuni[@]}"
  do 
    echo -ne "\t$k" >> $sqsf
  done
  echo "" >> $sqsf
  
  for j in cell_${i}/*.cif
  do
    pth=`dirname $j`/`basename $j .cif`
    name=`basename $j .cif`

    echo -n $j >> $sqsf

    cd ${cur_path}
    rm -rf $pth
    mkdir -p $pth
    cd $pth
    #mkdir cfg
    #rm -rf $pth/lammps
    #mkdir -p $pth/lammps
    #cd $pth/lammps

    cif2cell ${cur_path}/cell_${i}/${name}.cif --no-reduce -p lammps -o data_tmp.in
    
    for k in "${latuni[@]}"
    do 
      ln=`grep -e "xlo" -n data_tmp.in | sed -e 's/:.*//g'`
      cat data_tmp.in | awk -v lnx=$ln -v t=$k '{if(NR==lnx){printf "%9.5f %9.5f xlo xhi \n",$1*t,$2*t}else if(NR==(lnx+1)){printf "%9.5f %9.5f ylo yhi \n",$1*t,$2*t}else if(NR==(lnx+2)){printf "%9.5f %9.5f zlo zhi \n",$1*t,$2*t}else if(NR==(lnx+3)){printf "%9.5f %9.5f %9.5f xy xz yz \n",$1*t,$2*t,$3*t}else{print $0}}' > data.in
      ${PRG_lammps} -in ${cur_path}/in.lmp
      cr=`grep "Total Energy" log.lammps | tail -1 | awk '{printf "%8.3f",$5};'`
      echo -ne "\t$cr" >> $sqsf
    done
    echo "" >> $sqsf
  done 
done

echo "---------------------------------------------------------------"
cat $sqsf

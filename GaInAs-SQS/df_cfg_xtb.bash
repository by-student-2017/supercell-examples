#!/bin/bash

cif_name=`basename *.cif .cif`
cur_path=$PWD

if [[ -z "$PRG_xtb" ]]; then
  PRG_xtb="xtb"
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
    #rm -rf $pth/xtb
    #mkdir -p $pth/xtb
    #cd $pth/xtb

    cif2cell ${cur_path}/cell_${i}/${name}.cif --no-reduce -p vasp --vasp-cartesian-positions --vasp-format=5 -o data_tmp.poscar

    for k in "${latuni[@]}"
    do 
      cat data_tmp.poscar | awk -v t=$k '{if(NR==2){printf "%11.6f \n",$1*t}else{print $0}}' > data.poscar
      ${PRG_xtb} data.poscar --gfn 0 | tee log.xtb
      cr=`grep "TOTAL ENERGY" log.xtb | tail -1 | awk '{printf "%6.3e",$4*27.2114};'`
      echo -ne "\t$cr" >> $sqsf
    done
    echo "" >> $sqsf
  done 
done

echo "---------------------------------------------------------------"

cat $sqsf

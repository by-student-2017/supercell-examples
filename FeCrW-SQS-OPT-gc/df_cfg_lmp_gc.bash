#!/bin/bash

cif_name=`basename $2 .cif`
cur_path=$PWD

if [[ -z "$PRG_lammps" ]]; then
  PRG_lammps="lammps"
fi

#cells=( 1x1x2 1x2x2 )
cells=( $1 )
latuni=( 1.00 )

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
  
  for j in $( ls cell_${i} | grep ".cif" | sed "s/^/cell_${i}\//g" )
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
      mpirun -np 2 --allow-run-as-root ${PRG_lammps} -in ${cur_path}/in.lmp
      cr=`grep "Total Energy" log.lammps | tail -1 | awk '{printf "%8.3f",$5};'`
      echo -ne "\t$cr" >> $sqsf
    done
    echo "" >> $sqsf
  done 
done

echo "---------------------------------------------------------------"

#sort -k2 -g $sqsf
cd ${cur_path}
awk '(NR>1){print $0}' $sqsf | sort -k2 -g > tmp1
mn=`awk '(NR==1){print $2}' tmp1`
awk -v em=$mn '{printf "%s  %8.5f  %8.6e  %8.6e  %8.6e  %8.6e  %8.6e  %8.6e \n",$1,$2,exp(-($2 - em)/0.0257),exp(-($2 - em)/0.0257*298/673),exp(-($2 - em)/0.0257*298/873),exp(-($2 - em)/0.0257*298/1073),exp(-($2 - em)/0.0257*298/1273),exp(-($2 - em)/0.0257*298/1873)}' tmp1 > tmp2
es3=`gawk '{ sum += $3 }; END { print sum }' tmp2`
es4=`gawk '{ sum += $4 }; END { print sum }' tmp2`
es5=`gawk '{ sum += $5 }; END { print sum }' tmp2`
es6=`gawk '{ sum += $6 }; END { print sum }' tmp2`
es7=`gawk '{ sum += $7 }; END { print sum }' tmp2`
es8=`gawk '{ sum += $8 }; END { print sum }' tmp2`
echo "#Name of cif file | Total energy [eV] | (N(Ei)/SUM(N(Ei)))*100 at 298 K [%] | 673 K | 873 K | 1073 K | 1273 K | 1873 K" > result.txt
awk -v esu3=$es3 -v esu4=$es4 -v esu5=$es5 -v esu6=$es6 -v esu7=$es7 -v esu8=$es8 '{printf "%s  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f  %9.5f \n",$1,$2,($3/esu3*100),($4/esu4*100),($5/esu5*100),($6/esu6*100),($7/esu7*100),($8/esu8*100)}' tmp2 >> result.txt
cat result.txt
rm tmp1 tmp2

#!/bin/bash

lp=`grep "lattice parameter" pw.out | tail -1 | awk '{print $5*0.529177}'`
x=`grep -A 3 "crystal axes:" pw.out | sed 's/.*= (//' | sed 's/)//' | tail -3 | awk '{m+=$1} END{print m;}'`
y=`grep -A 3 "crystal axes:" pw.out | sed 's/.*= (//' | sed 's/)//' | tail -3 | awk '{m+=$2} END{print m;}'`
z=`grep -A 3 "crystal axes:" pw.out | sed 's/.*= (//' | sed 's/)//' | tail -3 | awk '{m+=$3} END{print m;}'`
#echo ${lp}": "${x}" "${y}" "${z}

# All
ln=`grep "number of atoms/cell" pw.out | tail -1 | awk '{print $5}'`
grep -A ${ln} "positions (alat units)" pw.out | sed 's/.*= (//' | sed 's/)//' > tmp
cat tmp | sed 1d | head -${ln} > tmp1
cat tmp | tail -${ln} > tmp2
paste tmp1 tmp2 > tmp3
#cat tmp3
msda=`awk -v lpu=${lp} -v xu=${x} -v yu=${y} -v zu=${z} '{print (lpu*xu*($1-$4))^2+(lpu*yu*($2-$5))^2+(lpu*zu*($3-$6))^2}' tmp3 | awk '{m+=$1} END{printf "%9.5e",m/NR}'`

# part
na=`grep "number of atomic types" pw.out | tail -1 | awk '{print $6}'`
splist=`grep -A ${na} "atomic species" pw.out | tail -${na} | awk '{printf "%s ",$1}'`
grep -A ${ln} "positions (alat units)" pw.out > ptmp
cat ptmp | sed 1d | head -${ln} > ptmp1
cat ptmp | tail -${ln} > ptmp2
for as in ${splist}
do
  grep ${as} ptmp1 | sed 's/.*= (//' | sed 's/)//' > nptmp1
  grep ${as} ptmp2 | sed 's/.*= (//' | sed 's/)//' > nptmp2
  paste nptmp1 nptmp2 > ptmp3
  pmsda=`awk -v lpu=${lp} -v xu=${x} -v yu=${y} -v zu=${z} '{print (lpu*xu*($1-$4))^2+(lpu*yu*($2-$5))^2+(lpu*zu*($3-$6))^2}' ptmp3 | awk '{m+=$1} END{printf "%9.5e ",m/NR}'`
  pmsdalist+=" "${pmsda}"("${as}")|"
done
echo "| "$msda" (all)|"$pmsdalist

rm -f -r tmp tmp1 tmp2 tmp3
rm -f -r ptmp1 ptmp2 ptmp3 nptmp1 nptmp2 

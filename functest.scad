precision = .1;
radius = 20;
startwinkel = 270;
endwinkel = 360;
schritt = 200;
basislaenge = 71.6;
basis = [
  [31.2, 17,-basislaenge/2], [27,12,basislaenge/2] 
];


function f(w,r) =  [r*sin(w), r*cos(w)];
//echo("f90=",f(90, r= 10));

//starta = f(0,r=10);
//echo("fstart=",starta);

//function applyFunc(rad=5,list=[f(0,r=rad)], i=1)= i>5 ?  //doesn't work, take care to nitialize the first list outside
// function applyFunc(rad=5,list, i=1)= i>5 ?  //doesn't work, take care to nitialize the first list outside
//    list :   //return the finisched list
//    applyFunc(rad=rad,list= [each list, let(fi = f(w=i,r=rad))  if (abs(abs(fi[1]) -abs(list[len(list)-1][1])) >.01) fi], i+1); //add only of abs difference is smaller than spec
// //echo("make list ",applyFunc(rad = 10)); //doesn't work!
// //echo("make list ",applyFunc(rad = 10, list=starta));
function absdiff(p1,p2) =  p1>p2? abs(p1 - p2): abs(p2 - p1);
function applyFunc( rad=5, prec=.01, sw=0, ew=90,step = 3, prec=.01, list ) =
 let( list = is_undef(list) ? [f(sw,r=rad)] : list,
   fi=f(sw,rad),
   pointdiff = absdiff(fi[1],list[len(list)-1][1])
     )
  //echo("sw = ",sw ,ew," diff:",pointdiff,prec,fi)
  (sw >= ew )? let(fi=f(ew,rad))[for(i=[0:len(list)-2]) if(absdiff(fi[1],list[i][1])> prec)list[i], fi] : 
  
  pointdiff >prec?
  applyFunc( rad=rad, prec=prec, sw=sw+step,ew=ew,step=step, list=[ each list, fi ] ):
  applyFunc( rad=rad, prec=prec, sw=sw+step,ew=ew,step=step, list=list );

function xaufrunden(toround, r, fn, sw, ew, prec=precision)= 
let(
    off=f(w=sw, r=r),
    step = (ew-sw)/fn,
    pos= applyFunc( rad=r, sw=sw, ew=ew,step = step, prec=prec)
    )
  [for(apos = pos) len(toround) == 1?[apos[0]+toround[0]]:
                   len(toround) == 2?[apos[0]+toround[0],apos[1]+toround[1]-off[1]]:
                   [apos[0]+toround[0],toround[1],toround[2]+apos[1]-off[1]]
  ] ;



 color("blue") translate([basis[0][0],basis[0][1],basis[0][2]]) cube(1,center= true);
pos= xaufrunden(toround = basis[0], r=10, fn=6, sw=0, ew=90);
  for(i=[0:len(pos)-1])
    let(mypos = pos[i])
   translate([mypos[0],mypos[1],mypos[2]]) cube(1,center= true);
// pos= applyFunc( rad=radius, sw=startwinkel, ew=endwinkel,step = (endwinkel - startwinkel)/schritt, prec=precision );
//  color("blue") translate([pos[0][0],pos[0][1],0]) cube(1,center= true);
// echo("applyFunc", pos);
//  color("blue") translate([pos[0][0],pos[0][1],0]) cube(1,center= true);
//  lastindex = len(pos)-1;
//  for(i=[1:lastindex-1])
//    let(mypos = pos[i])
//   translate([mypos[0],mypos[1],0]) cube(1,center= true);
//  color("red") translate([pos[lastindex][0],pos[lastindex][1],0]) cube(1,center= true);

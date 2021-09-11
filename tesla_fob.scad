use <sweep.scad>
use <tesla_logo.scad>
//include<schnitte.scad>;

//unteres Rechteck
basislaenge = 72;
basis = [
  [34.5, 17,-basislaenge/2], [32,12,basislaenge/2] 
];
eckenr =24;
dachr =84.6;//vielleicht
dachbr = 21;//19.5;
dachh = 20.5;
dachseg =56;



function flaeche2D(xy)=[
  [-xy[0]/2,xy[1]/2],
  [-xy[0]/2,-xy[1]/2],
  [xy[0]/2,-xy[1]/2],
  [xy[0]/2,xy[1]/2]
  ];
function quer2flaeche(xy)=[
  [-xy[0]/2,xy[1]/2,xy[2]],
  [-xy[0]/2,-xy[1]/2,xy[2]],
  [xy[0]/2,-xy[1]/2,xy[2]],
  [xy[0]/2,xy[1]/2,xy[2]]
  ];
function to2D(xy)=[
  let( z= xy[0][2]) 
  [
    for(i = [0:3])  [xy[i][0],xy[i][1]]],xy[0][2]
  ];


 //poly = round(basis[0],[5,0,90,3]);

 //schnitte = xaufrunden(toround = basis[1], r=10, fn=6, sw=0, ew=90);
 schnitte = [ each(xaufrunden(toround = basis[0], r=10, fn=20, sw=90, ew=180)), each(xaufrunden(toround = basis[1], r=24, fn=20, sw=0, ew=90))];
 //tesla_keyfob(schnitte);

 first = schnitte[0];
 f2 = flaeche2D(first);

 zoomif = 1+1/basislaenge;
 zoomf = 1+2/basislaenge;
 zooms = 1+1.3/basislaenge;

 translate([50,0,0]){tesla_case_bottom(bht=schnitte, wd=2); translate([0,2,0]) %tesla_keyfob(bht=schnitte); }
 tesla_case_top(bht=schnitte, wd=2);
 //Test zusammengesetzt und aufgeschnitten
//    difference()
//  {
//  union()
// {
//  {tesla_case_bottom(bht=schnitte, wd=2); translate([0,2,0]) %tesla_keyfob(bht=schnitte); }
//  translate([0,5+.1,0])tesla_case_top(bht=schnitte, wd=2);
// }
//  translate([0,14,35])cube([45,dachh+10,70], center = true);
//  }
//

module tesla_case_bottom(bht, wd=1)
{
  zoomif = 1+2*wd/basislaenge;
  zoomaf = 1+4*wd/basislaenge;
  difference()
  {
    union()
    {
      translate([0,-1,0])
	intersection()
	{
	  scale(zoomif)tesla_keyfob(bht);
	  color("blue")translate([0,6,0])cube([40,10,1.5*basislaenge], center = true);
	}
      translate([0,-1.5,0])
	intersection()
	{
	  scale(zoomaf)tesla_keyfob(bht);
	  color("blue")translate([0,4,0])cube([40,5,1.5*basislaenge], center = true);
	}
    }
    translate([0,wd,0])tesla_keyfob(bht);
  }
}

module tesla_case_top(bht, wd=1)
{
  zoomif = 1+2*wd/basislaenge;
  zoomaf = 1+4*wd/basislaenge;
  translate([0,-5,0])
  difference()
  {
    translate([0,wd,0])scale(zoomaf)tesla_keyfob(bht);
    union()
    {
	  cube([40,10,1.5*basislaenge], center = true);
      translate([0,wd,0])tesla_keyfob(bht);
      scale([1.01,1.0,1.01])tesla_case_bottom(bht=bht, wd=wd);
color("blue")
      scale([0.97,1.0,0.97])tesla_case_bottom(bht=bht, wd=wd);
  translate([0,-28,basislaenge/2-15])
  rotate([20,0,0])
  translate([0,40,0])
  rotate([-90,0,0])
scale(.1)
color("red")
  linear_extrude(height=20, center=true)
  tesla_logo();
    }
  }
}
module tesla_keyfob(bht)
{
  maxhull = max3D(bht);
  minhull = min3D(bht);
  length = maxhull[2]-minhull[2];
  deviance = (maxhull[1]-minhull[1]);

  echo("incoming; ",bht);
  echo("max: ",maxhull, "min: ",minhull," totl:",length," deviance:",deviance);
  querschnitte = [ for(slice = bht) quer2flaeche(slice)];
  //echo("schnitte; ",querschnitte, " len ",len(querschnitte));
  translate([0,deviance*3/2,0])
  rotate([atan(deviance/length)/2,0,0])
  hull()
  {
    //for(scheibe3D=querschnitte) 
    //{
    //  ret = to2D(scheibe3D);
    //  scheibe = ret[0];
    //  z = ret[1];
    //  //echo("eine scheibe ",scheibe," @ ",z);
    //  //echo("eine scheibe ",scheibe3D," gibt ",to2D(scheibe3D));
    //  translate([0,0,z]) polygon(scheibe);
    //}
    // //draw outline
    // for(spos = basis)
    // {
    // s1 = quer2flaeche(spos);
    // spliz = to2D(s1);
    //  sc1= spliz[0];
    //  z1 = spliz[1];
    //  color("magenta")translate([0,0,z1]) polygon(sc1);
    // }
    sweep(querschnitte,true);
    //translate([0,0,-(basislaenge-dachr)/2])rotate([0,90,0])rotate_extrude(angle=180, $fn = 150)translate([dachr/2,-dachh/2,0])square(dachbr, dachh);
    translate([0,-5.5,-(abs(basislaenge-dachr))/2])rotate([0,90,0])difference()
    {
      union()
      {
	color("red") 
	  translate([0,-dachr/2+dachh,0])
	  cylinder(d=dachr, h=dachbr, $fa=1, center = true);
      }
      union()
      {
	translate([0,-dachr/2,0])cube([2*dachr,dachr, dachbr+2], center = true);
	color("green") 
	  translate([dachr-(abs(basislaenge-dachr)),0,0])cube([dachr,2*dachr, 40], center = true);
      }
    }
  }
}

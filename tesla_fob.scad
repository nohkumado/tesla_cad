use <sweep.scad>

//unteres Rechteck
basislaenge = 71.6;
basis = [
  [39.2, 16,-basislaenge/2], [30.8,11,basislaenge/2] 
];
eckenr =24;
dachr =84.6;//vielleicht
dachbr = 21;//19.5;
dachh = 20.5;
dachseg =56;



function quer2flaeche(xy)=[
  [-xy[0]/2,xy[1]/2,xy[2]],
  [-xy[0]/2,-xy[1]/2,xy[2]],
  [xy[0]/2,-xy[1]/2,xy[2]],
  [xy[0]/2,xy[1]/2,xy[2]]
  ];

  //polygon(basis);

  //color("red") cube(5);

  //sweep(querschnitte,true);
   //translate([0,50,0])
   rotate([0,90,0])
   difference()
 {
 translate([0,5,0])cube([1,dachh+10,basislaenge+10], center = true);
 tesla_keyfob(basis);
 }

//  rotate([0,90,0])
//  difference()
//{
//translate([0,5,0])cube([1,dachh+10,basislaenge+10], center = true);
//tesla_keyfob(basis);
//}
//   translate([0,-50,0])
//   rotate([90,0,90])
//   difference()
// {
// translate([0,0,0])cube([45,1,basislaenge+10], center = true);
// tesla_keyfob(basis);
// }
//
//   difference()
// {
// translate([0,5,0])cube([45,dachh+10,1], center = true);
// translate([0,0,4])tesla_keyfob(basis);
// }

module tesla_keyfob(bht)
{
  querschnitte = [ for(slice = bht) quer2flaeche(slice)];
  //echo("schnitte; ",querschnitte);
  hull()
  {
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

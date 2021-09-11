//color("red") import("tesla_logo.svg");
//translate([49.5,0,-1])
//translate([100,0,0])tesla_logo();
//%square(100,center = true);
color("red")
linear_extrude(height=20) tesla_logo();

translate([100,0,0])
difference()
{
cube([120,120,2],center = true);
translate([0,0,-5])linear_extrude(height=20) tesla_logo();
}

module tesla_logo()
{
  dreieck = [[-10,0],[0,-13], [10,0]];
  spitze = [[-15,0],[0,-080], [15,0]];
color("red")
    //scale(10/9) //make it to size 100
  translate([0,-82,0]) //center it
  {
    intersection()
    {
      union()
      {
	difference() //Aussenring
	{
	  circle(d=254, $fa=1);
	  circle(d=242, $fa=1);
	}
	difference() //Innenring
	{
	    circle(d=238, $fa=1); //Innen gross
	  union()
	  {
	color("blue")
	    circle(d=210, $fa=1);
	    translate([0,120,0])polygon(dreieck);
	    difference()
	    {
	      umaske(); //schneide dir Spitze raus
	      difference()
	      {
	        union()
	        {
	          translate([23.8,96.2,0]) square(14); //Enden wegnehmen
	          translate([-37.7,96.2,0]) square(14);
	        }
	        union()
	        {
	          translate([23.7,102.1,-0]) circle(d=12, $fn=40);
	          translate([-23.7,102.1,-0]) circle(d=12, $fn=40);
	        }
	      }
	    }
	  }
	}
      }
      translate([0,141,0]) circle(d=100, $fa=1); //obere Selektion
    }
    difference() //Spitze, unschön, weiss aber nicht wie es beser gemacht werden könnte
    {
      translate([0,117,-0])polygon(spitze);
      translate([0,120,-0])polygon(dreieck);
    }
  }
}

module umaske()
{
  maske = [[-29,0],[0,-080], [29,0]];
  intersection()
  {
      translate([0,109,-0])polygon(maske);
      translate([0,-251.5,-0]) circle(d=720.8, $fa=1);
  }
}

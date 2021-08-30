//color("red") import("tesla_logo.svg");
translate([49.5,0,-1])tesla_logo();


module tesla_logo()
{
  dreieck = [[-10,0],[0,-13], [10,0]];
  spitze = [[-15,0],[0,-080], [15,0]];
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
	union()
	{
	  circle(d=238, $fa=1);
	}
	union()
	{
	  circle(d=210, $fa=1);
	  translate([0,120,-1])linear_extrude(height=3)polygon(dreieck);
	  difference()
	  {
	    umaske();
	    difference()
	    {
	      union()
	      {
		translate([23.8,96.2,-0]) square(14);
		translate([-37.7,96.2,-0]) square(14);
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
    translate([0,120,-1])linear_extrude(height=3)polygon(dreieck);
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


//cylinder paramters; the item you want to store
cylDiameter         = 14.5;   //cylinder diameter; 14.5 for typical AA 10.5 for AAA
cylSlack            = 0.5;    //wiggle room around cylinder, 0.5 seems to be okay
cylEnclosedHeight   = 23;     //amount of the battery that sits in the enclore, about 50% is good
cylWall             = 0.8;    //minimum thickness of the plastic wall between objects, let this be a multiple of your 3d printers nozzle
nippleHeight        = 1;

//container paramters; the box the stored item sits in
xSlots      = 3;
ySlots      = 5;
contBottom  = 1;  //multiple of printer layer height
contWall    = 0.8;  //multiple of printer nozzle width

//global variables, no need to touch these
$fn = 44; //works best if modulo 4, since cylinders touch on 4 sides, 24 seems okay
cylTotal = cylDiameter+cylSlack+cylWall;
containerX = cylTotal*xSlots;
containerY = cylTotal*ySlots;


difference(){
    container("round"); //available types; square,round,light
    slots();
}


module container(type)
{
  if (type == "square") {
    linear_extrude(cylEnclosedHeight+contBottom+nippleHeight)
    {
        offset(r = contWall){
            square(size=[containerX-cylWall,containerY-cylWall],center=true);
        }        
    }
  } else if (type == "round" || type == "light") {
    union()
    {
        translate([-(containerX/2)+(cylTotal/2), -(containerY/2)+(cylTotal/2)])
        {
            for (i = [0 : cylTotal : cylTotal*ySlots-1]) 
            {
                translate([0,i,0])
                for (i = [0 : cylTotal : cylTotal*xSlots-1]) 
                {
                    translate([i,0,0])
                    cylinder(d=cylTotal+contWall,h=cylEnclosedHeight+contBottom+nippleHeight);        
                }
            }
        }
        if (type == "round")
        {
          linear_extrude(cylEnclosedHeight+contBottom+nippleHeight)
          {
              square(size=[containerX-cylTotal,containerY-cylTotal],center=true);
          }
        }
    }
  } else if (type == "") {
    
  }
}

module slots() 
{
    translate([-(containerX/2)+(cylTotal/2), -(containerY/2)+(cylTotal/2)])
    {
        for (i = [0 : cylTotal : cylTotal*ySlots-1]) 
        {
            translate([0,i,0])
            for (i = [0 : cylTotal : cylTotal*xSlots-1]) 
            {
                translate([i,0,contBottom+nippleHeight])
                cylinder(d=cylTotal-cylWall,h=cylEnclosedHeight+1); //+1 is only to make preview less glitchy
                translate([i,0,contBottom])
                cylinder(d=(cylTotal-cylWall)/2,h=nippleHeight+1); //+1 is only to make preview less glitchy
            }
        }
    }
}
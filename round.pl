#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
no warnings "experimental::signatures";
use feature "signatures";


use Data::Dumper;

sub round($val,$rad,$step,$prec)
{
  #my ($val,$rad,$step,$prec) = @_;
  my $b=@{$val}[0];
  my $h=@{$val}[1];
  my $z=@{$val}[2];
  my $r=@{$rad}[0];
  my $sw=@{$rad}[1];
  my $ew=@{$rad}[2];
  my $fn=@{$step}[0];
  #my $off=$r*(sin($ew)-sin($sw));
  my $off=$r*(sin($ew));
  print("breite$b, hoehe=$h, t=$z, rad=$r, start=$sw, end=$ew, schritt=$fn, off=$off\n");

  my @result = [];
  my $index = 0;
  my $lastval = -1000000;
  #print("running from $sw to $ew division with ($ew/$fn)=".($ew/$fn)."\n");

  for(my $w=$sw; $w <=$ew; $w += $ew/$fn) 
  {
    my $acty = ($z >0)?$z-$off+$r*sin($w):$z+$off-$r*sin($w);
    my $actx = $b-$r*sin(0+$w);
    my $diff = abs(abs($acty) - abs($lastval));
    #print("acting winkel:$w $acty - $lastval = $diff\n");
    if($lastval ==-1000000 || $diff > $prec) 
    {
      $lastval = $acty;
      $result[$index] = [$actx, $h,$acty];
      #push(@result,[$actx, $h,$acty]);
      #print("saved \@$index : [$actx, $h,$acty]\n");
      #print("saved \@$index : ".Dumper([$actx, $h,$acty])." in ".Dumper(\@result)."\n");
      $index++;
    }
    #else {print("REJECTED \@$index : [$actx, $h,$acty] : $diff\n");}
  }
  return \@result;
}

#START variables
my $basislaenge = 71.6;
my @basis = (
    [31, 17,-$basislaenge/2], [27,12,$basislaenge/2] 
    );
my $rounding = [12,6,6];

#print("Starting execution \n");
my $backref = round($basis[0],[5,-60,90,3],$rounding,.1 );
#print("round1 got back ".Dumper($backref)."\n");
my @result = ();
my $index = 0;
foreach my $line(  @{$backref})
{  
  #push(@result,$line); //adss an empty recored??
  $result[$index] = $line;
  $index++;
  #print("pushed ".Dumper($line)."\n");
}
#print("Starting execution of endpiece\n");
$backref = round($basis[1],[3,0,90,3],$rounding,.1 );
#print("round2 got back ".Dumper($backref)."\n");
foreach my $line(  @{$backref})
{  
  #push(@result,$line);
  $result[$index] = $line;
  $index++;
  #print("pushed ".Dumper($line)."\n");
}
print("result now : ".Dumper(\@result)."\n");

if(open(FH,">","schnitte.scad"))
{
  print(FH "schnitte = [\n");
  foreach my $line( @result)
  {
    my @ml = @{$line};

    print(FH "[".$ml[0].",".$ml[1].",".$ml[2]."],\n") if(defined($ml[0]));
  }
  print(FH "];\n");
  close(FH);

}
#print("rounding ".Dumper($backref));
#print("end execution ");

# sub round($val=[1,1,1],@rad = [10,0,90],@step = [70,3,3])


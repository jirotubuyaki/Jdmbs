# calculate relationship of companies.
# @input $n is company number.
# @output is "data.csv" at current directory.
my $n = 6;
my $corelation = 1;
my $start = 0;
my $end = 0;
my $flag = "off";

my @path =();

my @connect_companies;
my @corelation_companies;

for(my $i=1;$i<=$n;$i++){
	for(my $j=1;$j<=$n;$j++){
		$connect_companies[i][j] = 0;
	}
}
# @input $connect_companies[i][j] = 0.8 is company i affect to company j.
# please change $connect_companies[i][j].
$connect_companies[1][2] = 0.8;
$connect_companies[1][5] = 0.6;
$connect_companies[1][4] = -0.8;

$connect_companies[2][1] = 0.2;
$connect_companies[2][3] = 0.5;
$connect_companies[2][5] = 0.4;

$connect_companies[3][2] = 0.6;

$connect_companies[4][1] = -0.8;

$connect_companies[5][1] = 0.1;
$connect_companies[5][2] = 0.3;
$connect_companies[5][6] = -0.2;

$connect_companies[6][5] = -0.2;



for(my $i=1;$i<=$n;$i++){
	for(my $j=1;$j<=$n;$j++){
		if($i != $j){
			$start = $i;
			$end = $j;
			@path = ();
			&DFS($i);
		}
	}
}

sub DFS{
	my $a = $_[0];
	my $count = scalar @path;
	if($count <= 6){
		push @path,$a;
		for(my $k=1;$k<=$n;$k++){
			if(($a != $k)&&($start != $k)&&($connect_companies[$a][$k] != 0)){
				if($k == $end){
					print "$start:$end: @path $k\n";
					$corelation = 1;
					my $count = 1;
					my $item_before;
					foreach my $item (@path){
						if($count == 1){
							$item_before = $item;
						}
						else{
							$corelation = $corelation * $connect_companies[$item_before][$item];
							$item_before = $item;
						}
						$count++;
					}
					$corelation = $corelation * $connect_companies[$item_before][$k];
					$corelation_companies[$start][$end] = $corelation_companies[$start][$end] + $corelation;
				}
				else{
					$flag = "off";
					foreach my $same (@path){
						if($same eq $k){
							$flag = "on";
						}
					}
					if($flag eq "off"){
						&DFS($k);
					}
				}
			}
		}
		pop @path;
	}
}
# @output file is "data.csv" at current directory.
$file = "data.csv";
open (OUT, ">$file") or die "$!";
for(my $i=1;$i<=$n;$i++){
	for(my $j=1;$j<=$n;$j++){
		if($i eq $j){
			print OUT "1";
		}
		print OUT "$corelation_companies[$i][$j]";
		if($j ne $n){
			print OUT ",";
		}

	}
	print OUT "\n";
}

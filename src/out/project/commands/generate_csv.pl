use strict;
use warnings;
use ElectricCommander;
my $ec = new ElectricCommander;

open(CSV, ">", "report.csv") || die "Could not open report.csv file";

my %metrics = ();
my $units = $ec->getProperties({path => "/myProject/units"});
foreach my $unit($units->findnodes("//property")) {
    my $metric = $unit->findvalue("propertyName");
    if ($metric ne "emake_build_duration") {
        $metrics{$metric} = $unit->findvalue("value");
    }
}
print CSV "configuration_id,agents_per_host,emake_build_duration (s)";
for my $metric (sort keys %metrics) {
    print CSV "," . $metric . " (" . $metrics{$metric} . ")";
}
print CSV "\n";

my $configs = $ec->getProperties({path => "/myProject/metrics"});
foreach my $config_sheet($configs->findnodes("//property")) {
    my $config = $config_sheet->findvalue("propertyName");
    my %counts = ();
    my $counts = $ec->getProperties({path => "/myProject/metrics/$config"});
    foreach my $count_sheet($counts->findnodes("//property")) {
        $counts{$count_sheet->findvalue("propertyName")} = 1;
    }
    foreach my $count (sort keys %counts) {
        my $duration = $ec->getProperty(
			    "/myProject/metrics/$config/$count/emake_build_duration")
				->findvalue("//value")->value();
        print CSV "$config,$count,$duration";
        for my $metric (sort keys %metrics) {
			my $value = $ec->getProperty("/myProject/metrics/$config/$count/$metric")
				->findvalue("//value")->value();
			print CSV ",$value";
        }
        print CSV "\n";
    }
}

close(CSV);

use strict;
use warnings;
use ElectricCommander;
my $ec = ElectricCommander->new({debug => 0});

my $agents_per_host = $ec->getProperty("agents_per_host")
    ->findvalue("//value")->value();
my $configuration_id = $ec->getProperty("configuration_id")
    ->findvalue("//value")->value();
my $clean_command = $ec->getProperty("clean_command")
    ->findvalue("//value")->value();
my $commander_resource = $ec->getProperty("commander_resource")
    ->findvalue("//value")->value();
my $emake_cm = $ec->getProperty("emake_cm")
    ->findvalue("//value")->value();
my $emake_extra_flags = $ec->getProperty("emake_extra_flags")
    ->findvalue("//value")->value();
my $emake_install_path = $ec->getProperty("emake_install_path")
    ->findvalue("//value")->value();
my $working_directory = $ec->getProperty("working_directory")
    ->findvalue("//value")->value();
my $num_iterations = $ec->getProperty("num_iterations")
    ->findvalue("//value")->value();

my %metrics = ();

for (my $i = 1; $i <= $num_iterations; $i++)
{
    my $response = $ec->runProcedure({
        projectName => "$[projectName]",
        procedureName => "run_emake_single_build",
        actualParameter => [
            {
                actualParameterName => "clean_command",
                value => $clean_command
            },
            {
                actualParameterName => "commander_resource",
                value => $commander_resource
            },
            {
                actualParameterName => "emake_cm",
                value => $emake_cm
            },
            {
                actualParameterName => "emake_extra_flags",
                value => $emake_extra_flags
            },
            {
                actualParameterName => "emake_install_path",
                value => $emake_install_path
            },
            {
                actualParameterName => "working_directory",
                value => $working_directory
            },
        ]
    });
    my $job_id = $response->findvalue("//jobId")->value();
    $ec->setProperty("/myJob/report-urls/iteration: $i",
        "/commander/link/jobDetails/jobs/$job_id");
    $ec->setProperty("summary", "Running iteration $i/$num_iterations");
    my $status = "";
    while ($status ne "completed") {
        sleep 5;
        $status = $ec->getProperty("//jobs/$job_id/status")
            ->findvalue("//value")->value();
    }
    my $properties = $ec->getProperties({jobId => $job_id});
    foreach my $property($properties->findnodes("//property")) {
        my $name = $property->findvalue("propertyName")->value();
        if ($name =~ m/^metric_(.*)/) {
            my $value = $property->findvalue("value")->value();
            if ($i == 1) {
                $metrics{$name} = $value;
            } else {
                $metrics{$name} += $value;
            }
        }
    }
}

print "Averages over $num_iterations iterations:\n";
$ec->deleteProperty("/myProject/metrics/$configuration_id/$agents_per_host");
my $average_time = 0;
while(my($metric_name, $total) = each %metrics) {
    $metric_name =~ m/metric_(.*)/;
    my $metric = $1;
    my $average = sprintf("%.2f", $total / $num_iterations);
    $ec->setProperty("/myJob/$metric_name", $average);
    $ec->setProperty("/myProject/metrics/$configuration_id/$agents_per_host/$metric",
        $average);
    my $units = $ec->getProperty("/myProject/units/$metric")
        ->findvalue("//value")->value();
    if ($metric eq "emake_build_duration") {
        $average_time = $average;
    }
}

$ec->setProperty("summary", "Completed $num_iterations iterations; "
    . "average run time: ${average_time}s");

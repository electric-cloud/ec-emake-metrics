use strict;
use warnings;
use ElectricCommander;
my $ec = ElectricCommander->new({debug => 0});

my $agents_per_host_list = $ec->getProperty("agents_per_host")
    ->findvalue("//value")->value();
my $clean_command = $ec->getProperty("clean_command")
    ->findvalue("//value")->value();
my $commander_resource = $ec->getProperty("commander_resource")
    ->findvalue("//value")->value();
my $configuration_id = $ec->getProperty("configuration_id")
    ->findvalue("//value")->value();
my $emake_cm = $ec->getProperty("emake_cm")
    ->findvalue("//value")->value();
my $emake_extra_flags = $ec->getProperty("emake_extra_flags")
    ->findvalue("//value")->value();
my $emake_install_path = $ec->getProperty("emake_install_path")
    ->findvalue("//value")->value();
my $num_iterations = $ec->getProperty("num_iterations")
    ->findvalue("//value")->value();
my $working_directory = $ec->getProperty("working_directory")
    ->findvalue("//value")->value();

foreach my $agents_per_host(split(',', $agents_per_host_list)) {
    my $response = $ec->runProcedure({
        projectName => "$[projectName]",
        procedureName => "run_emake_iterate_builds",
        actualParameter => [
            {
                actualParameterName => "agents_per_host",
                value => $agents_per_host
            },
            {
                actualParameterName => "clean_command",
                value => $clean_command
            },
            {
                actualParameterName => "commander_resource",
                value => $commander_resource
            },
            {
                actualParameterName => "configuration_id",
                value => $configuration_id
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
                actualParameterName => "num_iterations",
                value => $num_iterations
            },
            {
                actualParameterName => "working_directory",
                value => $working_directory
            },
        ]
    });
    my $job_id = $response->findvalue("//jobId")->value();
    $ec->setProperty("/myJob/report-urls/agents: $agents_per_host",
        "/commander/link/jobDetails/jobs/$job_id");
    my $status = "";
    while ($status ne "completed") {
        sleep 5;
        $status = $ec->getProperty("//jobs/$job_id/status")
            ->findvalue("//value")->value();
    }
}

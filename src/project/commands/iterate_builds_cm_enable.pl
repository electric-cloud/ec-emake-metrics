use strict;
use warnings;
use ElectricCommander;
use XML::XPath;
my $ec = new ElectricCommander;

$ENV{PATH} = "$[emake_install_path]/bin:$[emake_install_path]/unsupported:$ENV{PATH}";

local $/;
open FILE, "cm_get_agents.log" or die "Couldn't open file: $!";
my $agents_xml = <FILE>;
close FILE;

my $agents = XML::XPath->new($agents_xml);
foreach my $agent($agents->findnodes("//agent")) {
    my $name = $agent->findvalue("agentName");
    my $host = $agent->findvalue("hostName");
    $name =~ m/$host-(.*)/;
    if ($1 <= $[agents_per_host]) {
        system("cmtool --cm $[emake_cm] changeAgentsEnabled true --agentName $name");
    }
}

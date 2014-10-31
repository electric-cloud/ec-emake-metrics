OVERVIEW:

The "Emake-Metrics" ElectricCommander/ElectricFlow plugin provides procedures to run ElectricAccelerator builds with different configurations and different numbers of enabled agents to find the best build times (plus lots of other metrics).

USAGE:

You must first install and promote the plugin (available in out/Emake-Metrics.jar). Then, go to the installed plugins list and click on Emake-Metrics to view the procedures. Here are the steps to find optimal emake speed:

* Create a list of the different configurations with which you will be testing emake. Each configuration represents a permutation of hardware variables (e.g. hyperthreading=on, RAM=32GB, hdd=SSD). Assign each of these configurations a unique identifier (e.g. c-1.1) and store this information in a spreadsheet for reference.
* To iterate over runs of emake, launch the run_emake_iterate_agents procedure (see the parameter descriptions for details). Do this for each configuration (be sure to pass the configuration identifier that you recorded earlier to the configuration_id parameter.
* The value of the agents_per_host parameter is very important. This is a comma-separated list of the number of enabled agents per host that you would like to test with. For example, if you want to test with up to 48 agents on a host, install the maximum number of hosts (i.e. 48) on each agent.  The value of agents_per_host might then look something like "12,18,24,30,36,42,48".
* The value of the num_iterations determines how many times to run each individual emake build and average out the metrics. The default of 3 is usually a good number unless you have wildly inconsistent builds in which case you may want to increase it.
* Once you're done running run_emake_iterate_agents for all your different configurations, launch the generate_csv procedure. This will create a file called report.csv in the job workspace. Chart the data to find the best build time or report on other key metrics.

SOURCES:

The sources are available in the src directory. They were built using the Commander SDK v2.0. The documentation for the SDK is available at http://docs.electric-cloud.com.

AUTHOR:

Tanay Nagjee, Electric Cloud Solutions Engineer
tanay@electric-cloud.com

DISCLAIMER:

This module is not officially supported by Electric Cloud.
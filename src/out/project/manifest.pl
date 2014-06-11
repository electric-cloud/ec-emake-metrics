@files = (
	['//project/propertySheet/property[propertyName="postp"]/value', 'postp.pl'],
	['//project/procedure[procedureName="generate_csv"]/step[stepName="generate"]/command', 'commands/generate_csv.pl'],
	['//project/procedure[procedureName="run_emake_iterate_agents"]/step[stepName="iterate"]/command', 'commands/iterate_agents.pl'],
	['//project/procedure[procedureName="run_emake_iterate_builds"]/step[stepName="cm_setup"]/command', 'commands/iterate_builds_cm_setup.sh'],
	['//project/procedure[procedureName="run_emake_iterate_builds"]/step[stepName="cm_enable"]/command', 'commands/iterate_builds_cm_enable.pl'],
	['//project/procedure[procedureName="run_emake_iterate_builds"]/step[stepName="iterate"]/command', 'commands/iterate_builds_iterate.pl'],
);

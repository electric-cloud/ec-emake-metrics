my @newMatchers = (
    {
      id      => "emake_finish",
      pattern => q{(Finished|Interrupted) build: (.*) Duration: (\d+):(\d+) \(m:s\)},
      action  => q{
        $::gCommander->setProperty("/myJobStep/summary", "Build: $2 ($1) in $3:$4");
        $::gCommander->setProperty("/myParent/emake_build_outcome", $1);
        $::gCommander->setProperty("/myParent/emake_build_id", $2);
        $::gCommander->setProperty("/myParent/metric_emake_build_duration", ($3 * 60) + $4);
      }
    },
    {
      id      => "emake_bandwidth_network_to_agent",
      pattern => q{Network to agent: (.*)MB, (.*) MB/s active, (.*) MB/s overall},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_to_agent", $1);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_to_agent_active", $2);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_to_agent_overall", $3);
      }
    },
    {
      id      => "emake_bandwidth_network_from_agent",
      pattern => q{Network from agent: (.*)MB, (.*) MB/s active, (.*) MB/s overall},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_from_agent", $1);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_from_agent_active", $2);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_network_from_agent_overall", $3);
      }
    },
    {
      id      => "emake_bandwidth_to_disk",
      pattern => q{To disk: (.*)MB, (.*) MB/s active, (.*) MB/s overall},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_to_disk", $1);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_to_disk_active", $2);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_to_disk_overall", $3);
      }
    },
    {
      id      => "emake_bandwidth_from_disk",
      pattern => q{From disk: (.*)MB, (.*) MB/s active, (.*) MB/s overall},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_from_disk", $1);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_from_disk_active", $2);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_from_disk_overall", $3);
      }
    },
    {
      id      => "emake_bandwidth_create_modify_usage",
      pattern => q{Retry on HTTP error: .*},
      action  => q{
      }
    },
    {
      id      => "emake_ignore_retry_on_http_error",
      pattern => q{Create/Modify usage: (.*)MB, (.*) MB/s active, (.*) MB/s overall},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_create_modify_usage", $1);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_create_modify_usage_active", $2);
        $::gCommander->setProperty("/myParent/metric_emake_bandwidth_create_modify_usage_overall", $3);
      }
    },
    {
      id      => "agent_metrics_command",
      pattern => q{Command:\s+(.*)s\s+\(\s*(.*)%\)},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_agent_command_time", $1);
        $::gCommander->setProperty("/myParent/metric_agent_command_percentage", $2);
      }
    },
    {
      id      => "agent_metrics_emake_request",
      pattern => q{Emake request:\s+(.*)s\s+\(\s*(.*)%\)},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_agent_emake_request_time", $1);
        $::gCommander->setProperty("/myParent/metric_agent_emake_request_percentage", $2);
      }
    },
    {
      id      => "agent_metrics_idle",
      pattern => q{Idle:\s+(.*)s\s+\(\s*(.*)%\)},
      action  => q{
        $::gCommander->setProperty("/myParent/metric_agent_idle_time", $1);
        $::gCommander->setProperty("/myParent/metric_agent_idle_percentage", $2);
      }
    },
);
unshift @::gMatchers, @newMatchers;

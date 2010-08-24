<?php

class durationTimeChart extends memoryUsageChart
{
    var $title = 'Plugin duration';
    var $enableCaching = TRUE;

    function __construct(&$config)
    {
        parent::__construct($config);
        $this->graphName = get_class();

        // Generate graph which displays the memory usage over time
        $this->series = array(
                'max_dur' => _('Max'),
                'avg_dur' => _('Avergae'),
                'min_dur' => _('Min'));
        $this->dataName = "usagePerInterval";
    }
}
?>
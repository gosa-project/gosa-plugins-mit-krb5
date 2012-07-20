<?php

class filterSID extends filterLDAPBlacklist {

	static function query($base, $scope, $filter, $attributes, $category, $objectStorage= "")
	{
		$sid = session::get("primarySIDSelect::sid");
		$filter = sprintf($filter, $sid);
		$result = filterLDAP::query($base, $scope, $filter, $attributes, $category, $objectStorage);
		$result = filterSID::addDefaultEntries($result);
		return(filterLDAPBlacklist::filterByBlacklist($result));
	}

	static function addDefaultEntries($entries){
		global $config;

		$sid = session::get("primarySIDSelect::sid");
		foreach(array("{$sid}-512" => _("Domain administrators"), 
		"{$sid}-513" => _("Domain users"), 
		"{$sid}-514" => _("Domain guests")) as $key => $name){
			$entry = array();
			$entry["cn"] = array("0" => $name, "count" => 1);
			$entry[] = "cn";
			$entry["objectClass"] = array(0 => "sambaGroupMapping", 1 => "posixGroup", 2 => "top", "count" => 3);
			$entry[] = "objectClass";
			$entry["description"] = array("0" => $name, "count" => 1);
			$entry[] = "description";
			$entry["sambaSID"] = array("0" => $key, "count" => 1);
			$entry[] = "sambaSID";
			$entry["dn"] = "dummy,{$key},". $config->current['BASE'];
			$entry["count"] = 4;
			
			$entries[] = $entry;
		}
		return($entries);
	}
}

?>

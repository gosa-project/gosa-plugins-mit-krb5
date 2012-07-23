<?php

class filterSID extends filterLDAPBlacklist {

	static function query($base, $scope, $filter, $attributes, $category, $objectStorage= "")
	{
		$sid = session::get("primarySIDSelect::sid");
		$filter = sprintf($filter, $sid);
		$result = filterLDAP::query($base, $scope, $filter, $attributes, $category, $objectStorage);
		return(filterLDAPBlacklist::filterByBlacklist($result));
	}
}

?>

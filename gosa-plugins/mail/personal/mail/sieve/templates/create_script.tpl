<h3>Create a new sieve script</h3>
{t}Please enter the name for the new script below. Script names must consist of lower case characters only.{/t}

<br>
<br>
<hr>
<br>
<b>{t}Script name{/t}</b> <input type='text' name='NewScriptName' value='{$NewScriptName}'>
<br>
<br>

<div class='seperator' style='border-top:1px solid #999; text-align:right; width:100%; padding-top:10px;'>
   <input type='submit' name='create_script_save' value='{msgPool type=applyButton}' id='create_script_save'>
   &nbsp;
   <input type='submit' name='create_script_cancel' value='{msgPool type=cancelButton}'>
</div>
<script language="JavaScript" type="text/javascript">
	<!--
	focus_field('NewScriptName');
	-->
</script>

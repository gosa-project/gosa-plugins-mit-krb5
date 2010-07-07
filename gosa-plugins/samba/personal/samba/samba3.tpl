<table style='width:100%; ' summary="{t}Samba configuration{/t}">


 <!-- Headline container -->
 <tr>
  <td style='width:50%; ' colspan="2">

   <h3>{t}Generic{/t}</h3>
  </td>
 </tr>
 <tr>
  <td>

   <table summary="{t}Path configuration{/t}">
    <tr>
     <td><label for="sambaHomePath">{t}Home directory{/t}</label></td>
     <td>
{render acl=$sambaHomePathACL checkbox=$multiple_support checked=$use_sambaHomePath}
      <input type='text' id="sambaHomePath" name="sambaHomePath" size=30 maxlength=60 value="{$sambaHomePath}">
{/render}
{render acl=$sambaHomeDriveACL  checkbox=$multiple_support checked=$use_sambaHomeDrive}
      <select size="1" name="sambaHomeDrive">
       {html_options values=$drives output=$drives selected=$sambaHomeDrive}
      </select>
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="sambaDomainName">{t}Domain{/t}</label></td>
     <td>
{render acl=$sambaDomainNameACL  checkbox=$multiple_support checked=$use_sambaDomainName}
      <select id="sambaDomainName" size="1" name="sambaDomainName"
       onChange="document.mainform.submit();">
       {html_options values=$domains output=$domains selected=$sambaDomainName}
      </select>
{/render}
{render acl=$sambaDomainNameACL  checkbox=$multiple_support checked=$use_sambaDomainName}
     <button type='submit' name='display_information'>{t}Show information{/t}</button>

{/render}
     </td>
    </tr>
   </table>
  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td>

   <table summary="{t}Profile and scirpt path settings{/t}">
    <tr>
     <td><label for="">{t}Script path{/t}</label></td>
     <td>
{render acl=$sambaLogonScriptACL  checkbox=$multiple_support checked=$use_sambaLogonScript}
      <input type='text' id="sambaLogonScript" name="sambaLogonScript" size=35 maxlength=60 value="{$sambaLogonScript}">
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="">{t}Profile path{/t}</label></td>
     <td>
{render acl=$sambaProfilePathACL  checkbox=$multiple_support checked=$use_sambaProfilePath}
      <input type='text' class="center" id="sambaProfilePath" name="sambaProfilePath" size=35 maxlength=60 value="{$sambaProfilePath}">
{/render}
     </td>
    </tr>
   </table>
  </td>
 </tr>
</table>

<hr>

<h3>{t}Terminal Server{/t}</h3>

<table style='width:100%; ' summary="{t}Terminal server settings{/t}">
 <tr>
  <td style='width:50%'>


{if $multiple_support}
   	<input class="center" type=checkbox name="use_tslogin" id="use_tslogin" value="1" 
		{if $use_tslogin} checked {/if}
		onClick="changeState('tslogin')">
	<input class="center" type=checkbox name="tslogin" id="tslogin" value="1" {$tslogin}
		{if !$use_tslogin} disabled {/if}>
{else}
{render acl=$AllowLoginOnTerminalServerACL}
   <input class="center" type=checkbox name="tslogin" id="tslogin" value="1" {$tslogin}
   	onclick="
		changeState('CtxWFHomeDir');
		changeState('CtxWFHomeDirDrive');
		changeState('CtxWFProfilePath');
		changeState('inherit');			
		changeTripleSelectState_2nd_neg('tslogin','inherit','CtxInitialProgram');
		changeTripleSelectState_2nd_neg('tslogin','inherit','CtxWorkDirectory');
		changeState('CtxMaxConnectionTimeF');
		changeState('CtxMaxDisconnectionTimeF');
		changeState('CtxMaxIdleTimeF');
		changeTripleSelectState('tslogin','CtxMaxConnectionTimeF','CtxMaxConnectionTime');
		changeTripleSelectState('tslogin','CtxMaxDisconnectionTimeF','CtxMaxDisconnectionTime');
		changeTripleSelectState('tslogin','CtxMaxIdleTimeF','CtxMaxIdleTime');
		changeState('connectclientdrives');
		changeState('connectclientprinters');
		changeState('defaultprinter');
		changeState('shadow');
		changeState('brokenconn');
		changeState('reconn');
	">
{/render}
{/if}
   <i>{t}Allow login on terminal server{/t}</i>
   <table summary="{t}Terminal server connection settings{/t}">
    <tr>
     <td><label for="CtxWFHomeDir">{t}Home directory{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxWFHomeDir}
      <input type='text' id="CtxWFHomeDir" name="CtxWFHomeDir" size=30 maxlength=60 value="{$CtxWFHomeDir}" {$tsloginstate}>
{/render}
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxWFHomeDirDrive}
      <select size="1" id="CtxWFHomeDirDrive" name="CtxWFHomeDirDrive"  {$tsloginstate}>
       {html_options values=$drives output=$drives selected=$CtxWFHomeDirDrive}
      </select>
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="CtxWFProfilePath">{t}Profile path{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxWFProfilePath}
      <input type='text' id="CtxWFProfilePath" name="CtxWFProfilePath" size=35 maxlength=60 value="{$CtxWFProfilePath}" {$tsloginstate}>
{/render}
     </td>
    </tr>
   </table>
  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td>

{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_inherit}
   <input class="center" type=checkbox id="inherit" name="inherit" {if $inheritstate} checked {/if}
    {$tsloginstate}
	onClick="changeState('CtxInitialProgram');
 		 changeState('CtxWorkDirectory');"
	
	> 
{/render}
   <i>{t}Inherit client config{/t}</i>
   <table summary="{t}Client configuration{/t}">
    <tr>
     <td><label for="CtxInitialProgram">{t}Initial program{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxInitialProgram}
      <input type='text' id="CtxInitialProgram" name="CtxInitialProgram" size=35 maxlength=60 value="{$CtxInitialProgram}" {$inheritstate} {$tsloginstate}>
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="CtxWorkDirectory">{t}Working directory{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxWorkDirectory}
      <input type='text' id="CtxWorkDirectory" name="CtxWorkDirectory" size=35 maxlength=60	value='{$CtxWorkDirectory}' {$inheritstate} {$tsloginstate}>
{/render}
     </td>
    </tr>
   </table>
  </td>
 </tr>
</table>

<hr>

<table style='width:100%; ' summary="{t}Connection timeout settings{/t}">

 <tr>
  <td>

   <i>{t}Timeout settings (in minutes){/t}</i>
   <table summary="{t}Connection timeout settings{/t}">
    <tr>
     <td>
{if $multiple_support}
<input type="checkbox" name="use_CtxMaxConnectionTimeF" {if $use_CtxMaxConnectionTimeF} checked {/if}
	onClick="changeState('CtxMaxConnectionTimeF');" class="center"
	>
{/if}
{render acl=$AllowLoginOnTerminalServerACL}
      <input 		id="CtxMaxConnectionTimeF" 	type="checkbox" class="center" name="CtxMaxConnectionTimeF" 
			{if !$use_CtxMaxConnectionTimeF && $multiple_support} disabled {/if}
			value="1" 			{$CtxMaxConnectionTimeF} 	
			onclick="changeState('CtxMaxConnectionTime')" {$tsloginstate}>
{/render}

      <label for="CtxMaxConnectionTimeF">{t}Connection{/t}</label>
     </td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL}
      <input name="CtxMaxConnectionTime" type="text" id="CtxMaxConnectionTime" size=5 maxlength=5 value="{$CtxMaxConnectionTime}" 
			{if !$CtxMaxConnectionTimeF ||  $tsloginstate == "disabled"} disabled  {/if}>
{/render}
     </td>
    </tr>
    <tr>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxMaxDisconnectionTimeF}
      <input id="CtxMaxDisconnectionTimeF" type=checkbox name="CtxMaxDisconnectionTimeF" value="1" {$CtxMaxDisconnectionTimeF} onclick="changeState('CtxMaxDisconnectionTime')" {$tsloginstate} class="center">
{/render}
      <label for="CtxMaxDisconnectionTimeF">{t}Disconnection{/t}</label>
     </td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL}
      <input name="CtxMaxDisconnectionTime" id="CtxMaxDisconnectionTime" type="text" size=5 maxlength=5 value="{$CtxMaxDisconnectionTime}" 
			{if $tsloginstate == "disabled" || !$CtxMaxDisconnectionTimeF} disabled  {/if}>
{/render}
     </td>
    </tr>
    <tr>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_CtxMaxIdleTimeF}
      <input id="CtxMaxIdleTimeF" type=checkbox name="CtxMaxIdleTimeF" value="1" {$CtxMaxIdleTimeF} onclick="changeState('CtxMaxIdleTime')" {$tsloginstate} class="center">
{/render}
      <label for="CtxMaxIdleTimeF">{t}IDLE{/t}</label>
     </td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL}
      <input name="CtxMaxIdleTime" id="CtxMaxIdleTime" size=5 maxlength=5 type="text" value="{$CtxMaxIdleTime}" 
			{if !$CtxMaxIdleTimeF || $tsloginstate == "disabled"} disabled  {/if}>
{/render}
     </td>
    </tr>
   </table>
  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td>


   <i>{t}Client devices{/t}</i>
   <table summary="{t}Client devices{/t}">
    <tr>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_connectclientdrives}
      <input id="connectclientdrives" type=checkbox name="connectclientdrives" value="1" {$connectclientdrives} {$tsloginstate} class="center">
{/render}
      <label for="connectclientdrives">{t}Connect client drives at logon{/t}</label>
     </td>
    </tr>
    <tr>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_connectclientprinters}
      <input id="connectclientprinters" type=checkbox name="connectclientprinters" value="1" {$connectclientprinters}{$tsloginstate} class="center">
{/render}
      <label for="connectclientprinters">{t}Connect client printers at logon{/t}</label>
     </td>
    </tr>
    <tr>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_defaultprinter}
      <input id="defaultprinter" type=checkbox name="defaultprinter" value="1" {$defaultprinter} {$tsloginstate} class="center">
{/render}
      <label for="defaultprinter">{t}Default to main client printer{/t}</label>
     </td>
    </tr>
   </table>

  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td style='width:50%'>

   <i>{t}Miscellaneous{/t}</i>
   <table summary="{t}Miscellaneous{/t}">
    <tr>
     <td>
      <label for="shadow">{t}Shadowing{/t}</label>
     </td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_shadow}
      <select id="shadow" size="1" name="shadow" {$tsloginstate}>
       {html_options options=$shadow selected=$shadowmode}
      </select>
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="brokenconn">{t}On broken or timed out{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_brokenconn}
      <select id="brokenconn" size="1" name="brokenconn" {$tsloginstate}>
       {html_options options=$brokenconn selected=$brokenconnmode}
      </select>
{/render}
     </td>
    </tr>
    <tr>
     <td><label for="reconn">{t}Reconnect if disconnected{/t}</label></td>
     <td>
{render acl=$AllowLoginOnTerminalServerACL  checkbox=$multiple_support checked=$use_reconn}
      <select id="reconn" size="1" name="reconn" {$tsloginstate}>
       {html_options options=$reconn selected=$reconnmode}
      </select>
{/render}
     </td>
    </tr>
   </table>

  </td>
 </tr>
</table>

<hr>

<h3>{t}Access options{/t}
</h3>

<table style='width:100%; ' summary="{t}Access options{/t}">

 <tr>
  <td style='width:50%; ' colspan="2">


    <table>
        <tr>
            <td>
                {render acl=$enforcePasswordChangeACL checkbox=$multiple_support checked=$use_enforcePasswordChange}
                 <input type='checkbox' value='1' name='enforcePasswordChange' 
                  {if $enforcePasswordChange} checked {/if} id='enforcePasswordChange'>
                {/render}
            </td>
            <td>
                <label for='enforcePasswordChange'>{t}Enforce password change{/t}</label>
            </td>
        </tr>
        <tr>
            <td>
                {render acl=$sambaAcctFlagsXACL  checkbox=$multiple_support checked=$use_no_expiry}
                 <input id="no_expiry" type=checkbox name="no_expiry" value="1" {$flagsX} class="center">
                {/render}
            </td>
            <td>
                <label for="no_expiry">{t}The password never expires{/t}</label>
            </td>
        </tr>            
        <tr>
            <td>
                {render acl=$sambaAcctFlagsNACL  checkbox=$multiple_support checked=$use_no_password_required}
                 <input id="no_password_required" type=checkbox name="no_password_required" value="1" {$flagsN} class="center">
                {/render}
            </td>
            <td>
                <label for="no_password_required">{t}Login from windows client requires no password{/t}</label>
            </td>
        </tr>            
        <tr>
            <td>
                {render acl=$sambaAcctFlagsLACL  checkbox=$multiple_support checked=$use_temporary_disable}
                 <input id="temporary_disable" type=checkbox name="temporary_disable" value="1" {$flagsD} class="center">
                {/render}
            </td>
            <td>
                <label for="temporary_disable">{t}Lock samba account{/t}</label>
            </td>
        </tr>            
            <td>                                                    
                {render acl=$cannotChangePasswordACL  checkbox=$multiple_support checked=$use_cannotChangePassword}
                 <input id="cannotChangePassword" type=checkbox name="cannotChangePassword" value="1" class="center"
                    {if $cannotChangePassword} checked {/if}>                                                    
                {/render}                                                                                     
            </td>                                                                                             
            <td>                                                                                              
                <label for="cannotChangePassword">{t}Cannot change password{/t}</label>                          
            </td>                                                                                             
        </tr>                                                                                                 
        <tr>
            <td>
            </td>
            <td>
                {if $additional_info_PwdMustChange}
                    <i>({$additional_info_PwdMustChange})</i>
                {/if}
            </td>
        </tr>            
    </table>

    <hr>

    {render acl=$sambaLogonHoursACL mode=read_active  checkbox=$multiple_support checked=$use_SetSambaLogonHours}
        {t}Samba logon times{/t}&nbsp;<button type='submit' name='SetSambaLogonHours'>{t}Edit settings...{/t}</button>
    {/render}
    <!-- /Samba policies -->

  </td>
  <td class='left-border'>

   &nbsp;
  </td>
  <td>

   <label for="workstation_list">{t}Allow connection from these workstations only{/t}</label>
   <br>

{if $multiple_support}
	<input type="checkbox" name="use_workstation_list" {if $use_workstation_list} checked {/if} class="center"
		onClick="changeState('workstation_list');">
   <select {if $multiple_support && !$use_workstation_list} disabled {/if} 
	id="workstation_list" style="width:100%;" name="workstation_list[]" size=10 multiple>
	
	{foreach from=$multiple_workstations item=item key=key}
		{if $item.UsedByAllUsers}
			<option value="{$key}">{$item.Name} ({t}Used by all users{/t})</option>
		{else}
			<option style='color: #888888; background: #DDDDDD;background-color: #DDDDDD;'
				value="{$key}">{$item.Name} ({t}Used by some users{/t})</option>
		{/if}
	{/foreach}
   </select>
   <br>
   <button type='submit' name='add_ws'>{msgPool type=addButton}</button>

   <button type='submit' name='delete_ws'>{msgPool type=delButton}</button>

{else}
	{render acl=$sambaUserWorkstationsACL}
	   <select id="workstation_list" style="width:100%;" name="workstation_list[]" size=5 multiple>
		{html_options values=$workstations output=$workstations}
	   </select>
	{/render}
	   <br>
	{render acl=$sambaUserWorkstationsACL}
	   <button type='submit' name='add_ws'>{msgPool type=addButton}</button>

	{/render}
	{render acl=$sambaUserWorkstationsACL}
	   <button type='submit' name='delete_ws'>{msgPool type=delButton}</button>

	{/render}
{/if}
  </td>
 </tr>
</table>

<input type="hidden" name="sambaTab" value="sambaTab">

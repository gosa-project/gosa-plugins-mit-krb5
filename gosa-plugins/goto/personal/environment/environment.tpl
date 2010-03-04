
<input type="hidden" name="iamposted" value="1">

<h3>{t}Profiles{/t}</h3>

<table summary="{t}Environment managment settings{/t}" width="100%">
 <tr>
  <td>   
   {if $multiple_support}
   {render acl=$gotoProfileACL checkbox=$multiple_support checked=$use_useProfile}
   <input class="center" type="checkbox" value="1" {if $useProfile} checked {/if} 
   name="useProfile" id="useProfile">{t}Use profile managment{/t}
   {/render}
   <br>
   {render acl=$gotoProfileServerACL checkbox=$multiple_support checked=$use_gotoProfileServer}
   {t}Profil path{/t}
   <select id="gotoProfileServer" name="gotoProfileServer">
    {foreach from=$gotoProfileServers key=key item=item}
    <option {if $gotoProfileServer == $key} selected {/if}value='{$key}'>{$item.DISPLAY}</option>
    {/foreach}
    <option disabled>&nbsp;</option>
   </select>
   {/render}
   <br>
   {render acl=$gotoProfileQuotaACL checkbox=$multiple_support checked=$use_gotoProfileQuota}
   <input type="text" name="gotoProfileQuota" value="{$gotoProfileQuota}" size="6" id="gotoProfileQuota">{t}MB{/t}
   {/render}
   <br>
   {render acl=$gotoProfileFlagCACL checkbox=$multiple_support checked=$use_gotoProfileFlagC}
   <input class="center" type="checkbox" name="gotoProfileFlagC" value="C" {$gotoProfileFlagCCHK} id="gotoProfileFlagC">&nbsp;
   {t}Cache profile localy{/t}
   {/render}
   
   {else}
   
   
   <table summary="{t}Profile managment{/t}">
    <tr>
     <td style="vertical-align:top">
      {render acl=$gotoProfileACL}
      <input class="center" type="checkbox" value="1" {$useProfileCHK} name="useProfile" id="useProfile" onclick="changeState('gotoProfileServer');changeState('gotoProfileFlagC');changeState('gotoProfileQuota');">
      {/render}
     </td>
     <td style="vertical-align:middle;">
      <label for="useProfile">{t}Use profile managment{/t}</label>
     </td>
    </tr>
    <tr>
     <td>&nbsp;
     </td>
     <td>
      <table summary="{t}Profile server managment{/t}">
       <tr>
        <td> 
         <label for="gotoProfileServer">{t}Profil path{/t}</label>
        </td>
        <td>
         {render acl=$gotoProfileServerACL}
         
         {if $gotoProfileServerWriteable}
         <select id="gotoProfileServer" name="gotoProfileServer">
          {foreach from=$gotoProfileServers key=key item=item}
          {if $item.ACL != ""}
          <option {if $gotoProfileServer == $key} selected {/if}value='{$key}'>{$item.DISPLAY}</option>
          {/if}
          {/foreach}
          <option disabled>&nbsp;</option>
         </select>
         {else}
         <select id="dummy_pS" name="dummy_pS" disabled >
          <option>{$gotoProfileServer}</option> 
         </select>
         {/if}
         {/render}
        </td>
       </tr>
       <tr>
        <td>
         <label for="gotoProfileQuota">{t}Profil quota{/t}</label> 
         <br>
         <br>
        </td>
        <td>
         {render acl=$gotoProfileQuotaACL}
         <input type="text" name="gotoProfileQuota" value="{$gotoProfileQuota}" size="6" id="gotoProfileQuota">{t}MB{/t}
         {/render}
         <br>
         <br>
        </td>
       </tr>
       <tr>
        <td colspan=2> 
         {render acl=$gotoProfileFlagCACL}
         <input class="center" type="checkbox" name="gotoProfileFlagC" value="C" {$gotoProfileFlagCCHK} id="gotoProfileFlagC">&nbsp;
         {/render}
         <label for="gotoProfileFlagC">{t}Cache profile localy{/t}</label>
        </td>
       </tr>
      </table>
     </td>
    </tr>
   </table>
   
   {/if}
   
  </td>
  <td style="vertical-align:top;width:50%;border-left:1px solid #B0B0B0">
   
   <table summary="{t}Kiosk profile settings{/t}">
    {if $kiosk_enabled}
    <tr>
     <td colwidth=2>
      <label for="kiosk_server">{t}Kiosk profile{/t}</label>
     </td>
    </tr>
    <tr>
     <td>	
      {if $multiple_support}
      <input type="checkbox" name="use_kiosk_server" value="1" {if $use_kiosk_server} checked {/if} 
      class="center" 
      onClick="changeState('kiosk_server');
      changeState('kiosk_profile');"> 
      {/if}
      {t}Server{/t}
      {render acl=$gotoKioskProfileACL}
      <select name='kiosk_server' id="kiosk_server" onChange='document.mainform.submit();'
      {if !$use_kiosk_server && $multiple_support} disabled {/if}>
      {html_options options=$kiosk_servers selected=$kiosk_server}
</select>
{/render}
</td>
<td>
 {if $kiosk_server != "none"}
 {t}Profile{/t}
 {render acl=$gotoKioskProfileACL}
 <select name='kiosk_profile' id="kiosk_profile"
 {if !$use_kiosk_server && $multiple_support} disabled {/if}>
 {html_options values=$kiosk_profiles output=$kiosk_profiles selected=$kiosk_profile}
</select>
{/render}
{else}
&nbsp;
{/if}
</td>
</tr>
{else}
<tr>
 <td>
  <label for="dummy1">{t}Kiosk profile{/t}</label>
 </td>
 <td>
  <select name="dummy1" disabled id="dummy1"><option disabled>&nbsp;</option></select>
  <input type="button" disabled name="dummy2" value="{t}Manage{/t}">
 </td>
</tr>
{/if}
<tr>
 <td colspan=2>
  <br>
  {render acl=$gotoProfileFlagLACL checkbox=$multiple_support checked=$use_gotoProfileFlagL}
  <input type="checkbox" name="gotoProfileFlagL" id="gotoProfileFlagL" value="L" {$gotoProfileFlagLCHK} class="center">
  {/render}
  <label for="gotoProfileFlagL">{t}Resolution changeable during session{/t}</label>
 </td>
</tr>
<tr>
 <td>
  {if $multiple_support}
  <input type="checkbox" value="1" class="center" name="use_gotoXResolution"
  onClick="changeState('gotoXResolution');" {if $use_gotoXResolution} checked {/if}>
  {/if}
  <label for="gotoXResolution">{t}Resolution{/t}</label>
 </td>
 <td>
  {render acl=$gotoXResolutionACL}
  <select name="gotoXResolution" id="gotoXResolution" {if !$use_gotoXResolution && $multiple_support} disabled {/if}>
   {html_options values=$gotoXResolutionKeys output=$gotoXResolutions selected=$gotoXResolution}
   <option disabled>&nbsp;</option>
  </select>
  {/render}
 </td>
</tr>
</table> 






</td>
</tr>
</table>

<hr>

<table summary="{t}Environment managment settings{/t}" width="100%">
 <tr>
  <td style="width:50%;border-right:1px solid #B0B0B0">
   <h3><label for="gotoShare">{t}Shares{/t}</label></h3>
   <table style="width:100%">
    <tr>
     <td>
      
      {render acl=$gotoShareACL}
      {$divlistShares}
      {/render}
      {render acl=$gotoShareACL}
      <input type="text" size=15 name="ShareUser" value="%u" title="{t}User used to connect to the share{/t}">@
      {/render}
      {render acl=$gotoShareACL}
      <select name="gotoShareSelection" title="{t}Select a share{/t}">
       {html_options values=$gotoShareSelectionKeys output=$gotoShareSelections}
       <option disabled>&nbsp;</option>
      </select>
      {/render}
      :
      {render acl=$gotoShareACL}
      <input type="text" size=15 name="gotoShareMountPoint" value="%H/Netzlaufwerke/%L/%S"
      title="{t}Mount path{/t}">
      {/render}
      {render acl=$gotoShareACL}
      <button type='submit' name='gotoShareAdd'>{msgPool type=addButton}</button> 
      
      {/render}
      <!-- <input type="submit" name="gotoShareDel" value="{t}Remove{/t}"> -->
     </td>
    </tr>
   </table>
  </td>
  <td style="vertical-align:top">
   <h3><label for="gotoLogonScript">{t}Logon scripts{/t}</label></h3>
   <table summary="{t}Logon script management{/t}" style="width:100%">
    <tr>
     <td>
      {render acl=$gotoLogonScriptACL}
      <select style="width:100%;" name="gotoLogonScript" multiple size=5 id="gotoLogonScript">
       
       {if $multiple_support}
       {foreach from=$gotoLogonScripts item=item key=key}
       {if $item.UsedByAllUsers}
       <option value="{$key}">{$item.LogonPriority}&nbsp;{$item.LogonName}&nbsp;[{$item.LogonDescription}] ({t}Used by all users{/t})</option>
       {else}
       <option style='color: #888888; background: #DDDDDD;background-color: #DDDDDD;' value="{$key}">{$item.LogonPriority}&nbsp;{$item.LogonName}&nbsp;[{$item.LogonDescription}] ({t}Used by some users{/t})</option>
       {/if}
       {/foreach}
       {else}
       {html_options values=$gotoLogonScriptKeys output=$gotoLogonScripts}
       <option disabled>&nbsp;</option>
       {/if}
      </select>
      {/render}
      
      <br>
      {render acl=$gotoLogonScriptACL}
      <button type='submit' name='gotoLogonScriptNew'>{msgPool type=addButton}</button>
      
      {/render}
      {render acl=$gotoLogonScriptACL}
      <button type='submit' name='gotoLogonScriptEdit' {if $gotoLogonScriptKeysCnt ==0} disabled {/if}
      >{t}Edit{/t}</button>
      
      {/render}
      {render acl=$gotoLogonScriptACL}
      <button type='submit' name='gotoLogonScriptDel' {if $gotoLogonScriptKeysCnt ==0} disabled {/if}
      >{msgPool type=delButton}</button>
      
      {/render}
     </td>
    </tr>
   </table> 
  </td>
 </tr>
</table>

<hr>

<table summary="{t}Environment managment settings{/t}" width="100%">
 <tr>
  <td style="border-right:1px solid #B0B0B0; width:50%; vertical-align:top">
   <h3><label for="gotoHotplugDevice_post">{t}Hotplug devices{/t}</label></h3> 
   <table style="width:100%" summary="{t}Hotplug device settings{/t}">
    <tr>
     <td>
      {render acl=$gotoHotplugDeviceACL}
      <select name="gotoHotplugDevice_post[]" size=5  style="width:100%;" id="gotoHotplugDevice_post" multiple>
       {if $multiple_support}
       {foreach from=$gotoHotplugDevices item=item key=key}
       {if $item.UsedByAllUsers}
       <option value="{$key}">{$item.name}&nbsp;[{$item.description}] ({t}Used by all users{/t})</option>
       {else}
       <option style='color: #888888; background: #DDDDDD;background-color: #DDDDDD;' value="{$key}">{$item.name}&nbsp;[{$item.description}] ({t}Used by some users{/t})</option>
       {/if}
       {/foreach}
       {else}
       {html_options values=$gotoHotplugDeviceKeys output=$gotoHotplugDevices}
       <option disabled>&nbsp;</option>
       {/if}
      </select>
      {/render}
     </td>
    </tr>
    <tr>
     <td>
      {render acl=$gotoHotplugDeviceACL}
      <button type='submit' name='gotoHotplugDeviceUse'>{msgPool type=addButton}</button>
      
      {/render}
      {render acl=$gotoHotplugDeviceACL}
      <button type='submit' name='gotoHotplugDeviceDel' {if !$gotoHotplugDevices} disabled {/if}>{msgPool type=delButton}</button>
      {/render}
     </td>
    </tr>
   </table>
  </td>
  <td>
   
   
   {if $multiple_support}
   
    <input type="checkbox" name="use_gotoPrinter" value="1" {if $use_gotoPrinter} checked {/if} class="center" onClick="$('div_gotoPrinter').toggle();"><b><label for="gotoPrinter">{t}Printer{/t}</label></<>
   
   <div id="div_gotoPrinter" {if !$use_gotoPrinter} style="display: none;" {/if}>
    <b>{t}Using this option will overwrite the complete printer settings for all currently edited objects!{/t}</b>
    <table style="width:100%" summary="{t}Printer settings{/t}">
     <tr>
      <td>
       {render acl=$gotoPrinterACL}
       <select style="width:100%;" name="gotoPrinterSel[]" multiple size=5 id="gotoPrinter">
        {html_options options=$gotoPrinter}
        <option disabled>&nbsp;</option>
       </select>
       {/render}
       <br>
       {render acl=$gotoPrinterACL}
       <button type='submit' name='gotoPrinterAdd'>{msgPool type=addButton}</button>
       
       {/render}
       {render acl=$gotoPrinterACL}
       <button type='submit' name='gotoPrinterDel' {if !$gotoPrinter} disabled {/if}
       >{msgPool type=delButton}</button>
       
       {/render}
       {render acl=$gotoPrinterACL}
       <button type='submit' name='gotoPrinterEdit' {if !$gotoPrinter} disabled {/if}
       >{t}Toggle admin{/t}</button>
       
       {/render}
       {render acl=$gosaDefaultPrinterACL}
       <button type='submit' name='gotoPrinterDefault' {if !$gotoPrinter||$is_group} disabled {/if}
       >{t}Toggle default{/t}</button>
       
       {/render}
      </td>
     </tr>
    </table>
   </div>
   
   {else}
   
   <h3><label for="gotoPrinter">{t}Printer{/t}</label></h3>
   <table style="width:100%" summary="{t}Printer settings{/t}">
    <tr>
     <td>
      {render acl=$gotoPrinterACL}
      <select style="width:100%;" name="gotoPrinterSel[]" multiple size=5 id="gotoPrinter">
       {html_options options=$gotoPrinter}
       <option disabled>&nbsp;</option>
      </select>
      {/render}
      <br>
      {render acl=$gotoPrinterACL}
      <button type='submit' name='gotoPrinterAdd'>{msgPool type=addButton}</button>
      
      {/render}
      {render acl=$gotoPrinterACL}
      <button type='submit' name='gotoPrinterDel' {if !$gotoPrinter} disabled {/if}
      >{msgPool type=delButton}</button>
      
      {/render}
      {render acl=$gotoPrinterACL}
      <button type='submit' name='gotoPrinterEdit' {if !$gotoPrinter} disabled {/if}
      >{t}Toggle admin{/t}</button>
      
      {/render}
      {render acl=$gosaDefaultPrinterACL}
      <button type='submit' name='gotoPrinterDefault' {if !$gotoPrinter||$is_group} disabled {/if}
      >{t}Toggle default{/t}</button>
      
      {/render}
     </td>
    </tr>
   </table>
   
   {/if}
   
  </td>
 </tr>
</table>
{if $multiple_support}
<input type="hidden" name="environment_multiple_posted" value="1">
{/if}
<script language="JavaScript" type="text/javascript">
<!-- // First input field on page
focus_field('useProfile');
-->
</script>


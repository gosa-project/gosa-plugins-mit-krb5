<b><font style="color:red">This plugin is only simulating the interface. Therefore it's not functional. Please don't use.</font></b>
<br>

{if $dialogState eq 'head'}
<h1>{t}Assigned ACLs for current entry{/t}</h1>
{$aclList}
<input type="submit" name="new_acl" value="{t}New ACL{/t}">
<p class="seperator">&nbsp;</p>
<div style='text-align:right;margin-top:5px'>
	<input type="submit" name="save_acl" value="{t}Ok{/t}">
	&nbsp;
	<input type="submit" name="cancel_acl" value="{t}Cancel{/t}">
</div>
{/if}

{if $dialogState eq 'create'}
<h1>{t}ACL type{/t} <select size="1" name="aclType" title="{t}Select an acl type{/t}" onChange="document.mainform.submit()">&nbsp;</option>{html_options options=$aclTypes selected=$aclType}<option disabled></select>&nbsp;{if $javascript eq 'false'}<input type="submit" value="{t}Apply{/t}" name="refresh">{/if}</h1>

<p class="seperator">&nbsp;</p>

<table style="width:100%">
 <tr>
  <td style="width:48%; vertical-align:top;">
   {t}Use members from{/t}
   <select name="target" onChange="document.mainform.submit()">
        {html_options options=$targets selected=$target}
        <option disabled>&nbsp;</option>
   </select>
   {if $javascript eq 'false'}<input type="submit" value="{t}Apply{/t}" name="refresh">{/if}<br><br>
  </td>
  <td>
  </td>
  <td>
  </td>
 </tr>
 <tr>
  <td style="width:48%">
   {t}Available members{/t}<br>
   <select style="width:100%;height:180px;" name="source[]" size="20" multiple title="{t}List message possible targets{/t}">
            {html_options options=$sources}
            <option disabled>&nbsp;</option>
   </select>
  </td>
  <td style="vertical-align:center; text-align:center">
   <input type="submit" value="&gt;" name="add">
   <br><br>
   <input type="submit" value="&lt;" name="del">
  </td>
  <td style="width:48%; vertical-align:top;">
   {t}Members{/t}<br>
   <select style="width:100%;height:180px;" name="recipient[]" size="20" multiple title="{t}List message recipients{/t}">
            {html_options options=$recipients}
            <option disabled>&nbsp;</option>
   </select>
  </td>
 </tr>
</table>

{if $aclType ne 'reset'}
{if $aclType ne 'role'}
{if $aclType ne 'base'}
<p class="seperator">&nbsp;</p>

<h1>{t}List of available ACL categories{/t}</h1>
{$aclList}
{/if}
{/if}
{/if}

{if $aclType eq 'base'}
<p class="seperator">&nbsp;</p>
<h1>{t}ACLs for this object{/t}</h1>
{$aclSelector}
{/if}

<p class="seperator">&nbsp;</p>
<div style='text-align:right;margin-top:5px'>
	<input type="submit" name="submit_new_acl" value="{t}Apply{/t}">
	&nbsp;
	<input type="submit" name="cancel_new_acl" value="{t}Cancel{/t}">
</div>
{/if}

{if $dialogState eq 'edit'}

<h1>{$headline}</h1>

{$aclSelector}

<p class="seperator">&nbsp;</p>
<div style='text-align:right;margin-top:5px'>
	<input type="submit" name="submit_edit_acl" value="{t}Apply{/t}">
	&nbsp;
	<input type="submit" name="cancel_edit_acl" value="{t}Cancel{/t}">
</div>
{/if}

<h3>{t}Kerberos kadmin access{/t}</h3>

  <table style='width:100%;'>
   <tr>
    <td>
		<table>
		 <tr>
		  <td>{t}Kerberos Realm{/t}{$must}</td>
		   {render acl=$goKrbRealmACL}
		  <td><input type='text' name="goKrbRealm" id="goKrbRealm" size=30 maxlength=60  value="{$goKrbRealm}"></td>
			{/render}
		 </tr>
		</table>
     </td>
    </tr>
{if $MIT_KRB}
    <tr>
     <td>
		<h3>{t}Policies{/t}</h3>
		<table style="width:100%;">
		 <tr>
		  <td>
		   {render acl=$goKrbPolicyACL}
		    {$divlist}
		   {/render}
		  </td>
		 </tr>
		</table>
		<input type='submit' name="policy_add" value="{msgPool type=addButton}">
     </td>
    </tr>
{/if}
   </table>

<p class='seperator'>&nbsp;</p>
<div style="width:100%; text-align:right;padding-top:10px;padding-bottom:3px;">
    <input type='submit' name='SaveService' value='{msgPool type=saveButton}'>
    &nbsp;
    <input type='submit' name='CancelService' value='{msgPool type=cancelButton}'>
</div>
<input type="hidden" name="goKrbServerPosted" value="1">

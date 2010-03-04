<h3>{t}Generic{/t}</h3>
<table width="100%">
	<tr>
		<td style='width:50%;'>
			<table summary="">
				<tr>
					<td>{t}Server identifier{/t}{$must}
					</td>
					<td>
{render acl=$goImapNameACL}
						<input type='text' name="goImapName" id="goImapName" size=40 maxlength=60 value="{$goImapName}" >
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}Connect URL{/t}{$must}
					</td>
					<td>
{render acl=$goImapConnectACL}
						<input type='text' name="goImapConnect" id="goImapConnect" size=40 maxlength=100 value="{$goImapConnect}" >
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}Admin user{/t}{$must}
					</td>
					<td>
{render acl=$goImapAdminACL}
						<input type='text' name="goImapAdmin" id="goImapAdmin" size=30 maxlength=60 value="{$goImapAdmin}" >
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}Password{/t}{$must}
					</td>
					<td>
{render acl=$goImapPasswordACL}
					<input type=password name="goImapPassword" id="goImapPassword" size=30 maxlength=60 value="{$goImapPassword}" >
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}Sieve connect URL{/t}{$must}
					</td>
					<td>
{render acl=$goImapSieveServerACL}
						<input type='text' name="goImapSieveServer" id="goImapSieveServer" size=30 maxlength=60 value="{$goImapSieveServer}">
{/render}
					</td>
				</tr>
			</table>
		</td>
		<td style="border-left:1px solid #A0A0A0;vertical-align:top;">
			<table>
				<tr>
					<td>
{render acl=$cyrusImapACL}
						<input type='checkbox' name='cyrusImap' value=1 {if $cyrusImap} checked {/if} > 
{/render}
					</td>
					<td>{t}Start IMAP service{/t}
					</td>
				</tr>
				<tr>
					<td>
{render acl=$cyrusImapSSLACL}
						<input type='checkbox' name='cyrusImapSSL' value=1 {if $cyrusImapSSL} checked {/if}> 
{/render}
					</td>
					<td>{t}Start IMAP SSL service{/t}
					</td>
				</tr>
				<tr>
					<td>
{render acl=$cyrusPop3ACL}
						<input type='checkbox' name='cyrusPop3' value=1 {if $cyrusPop3} checked {/if} > 
{/render}
					</td>
					<td>{t}Start POP3 service{/t}
					</td>
				</tr>
				<tr>
					<td>
{render acl=$cyrusPop3SSLACL}
						<input type='checkbox' name='cyrusPop3SSL' value=1 {if $cyrusPop3SSL} checked {/if} > 
{/render}
					</td>
					<td>{t}Start POP3 SSL service{/t}
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<hr>
<br>
<h3>Action</h3>
{if $is_new == "new"}
    {t}The server must be saved before you can use the status flag.{/t}
{elseif !$is_acc}
    {t}The service must be saved before you can use the status flag.{/t}
{/if}
<br>
<select name="action" title='{t}Set new status{/t}' 
	{if $is_new =="new" || !$is_acc} disabled {/if}
>
	<option value="none">&nbsp;</option>
    {html_options options=$Actions}
</select>
<input type='submit' name='ExecAction' title='{t}Set status{/t}' value='{t}Execute{/t}' 
	{if $is_new == "new" || !$is_acc} disabled {/if}
>

<hr>
<div style="width:100%; text-align:right;padding-top:10px;padding-bottom:3px;">
    <input type='submit' name='SaveService' value='{msgPool type=saveButton}'>
    &nbsp;
    <input type='submit' name='CancelService' value='{msgPool type=cancelButton}'>
</div>
<input type="hidden" name="goImapServerPosted" value="1">

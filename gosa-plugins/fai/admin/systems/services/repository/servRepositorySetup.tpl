<h3>{t}Repository{/t}</h3>

<table width="100%" summary=''>
	<tr>
		<td width="50%" valign="top" style="border-right:1px solid #A0A0A0">
			<table summary=''>
				<tr>
					<td>{t}Parent server{/t}
					</td>
					<td>
{render acl=$ParentServerACL}
						<select name="ParentServer">
							{html_options options=$ParentServers values=$ParentServerKeys selected=$ParentServer} 
						</select>
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}Release{/t}
					</td>
					<td>
{render acl=$ReleaseACL}
						<input type="text" value="{$Release}" name="Release">
{/render}
					</td>
				</tr>
				<tr>
					<td>{t}URL{/t}
					</td>
					<td>
{render acl=$UrlACL}
						<input type="text" size="40" value="{$Url}" name="Url">
{/render}
					</td>
				</tr>
			</table>
		</td>
		<td>
			{t}Sections{/t}<br>
{render acl=$SectionACL}
			{$Sections}
{/render}
{render acl=$SectionACL}
			<input type="text" 	name="SectionName" value="" style='width:100%;'>
{/render}
{render acl=$SectionACL}
			<input type="submit" 	name="AddSection"  value="{msgPool type=addButton}">
{/render}
		</td>
	</tr>
</table>
<input type='hidden' name='servRepositorySetup_Posted' value='1'>
<p class="plugbottom">
  <input type=submit name="repository_setup_save" value="{msgPool type=applyButton}">
  &nbsp;
  <input type=submit name="repository_setup_cancel" value="{msgPool type=cancelButton}">
</p>


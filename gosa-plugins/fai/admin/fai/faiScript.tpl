<table width="100%" summary="">
	<tr>
		<td width="50%" valign="top">
				<h3>{t}Generic{/t}</h3>
				<table summary="" cellspacing="4">
					<tr>
						<td>
							<LABEL for="cn">
							{t}Name{/t}{$must}
							</LABEL>
						</td>
						<td>
{render acl=$cnACL}
							<input type='text' value="{$cn}"  maxlength="80" size="45" disabled id="cn">
{/render}
						</td>
					</tr>
					<tr>
						<td>
							<LABEL for="description">
							{t}Description{/t}
							</LABEL>
						</td>
						<td>
{render acl=$descriptionACL}
							<input type='text' size="45" maxlength="80" value="{$description}" name="description" id="description" >
{/render}
						</td>
					</tr>
				</table>
		</td>
	</tr>
</table>
<p class="seperator">&nbsp;</p>
<table width="100%" summary="">
	<tr>
		<td>
				<h3>
						{t}List of scripts{/t}
				</h3>
				<table width="100%" summary="" style="border:1px solid #B0B0B0; " cellspacing=0 cellpadding=0>
				<tr>
					<td>
						{$Entry_divlist}
{if $sub_object_is_addable}
						<input type="submit" name="AddSubObject"     value="{msgPool type=addButton}"	title="{msgPool type=addButton}" >
{else}
						<input type="submit" name="Dummy2"     value="{msgPool type=addButton}"	title="{msgPool type=addButton}" disabled>
{/if}
					</td>
				</tr>
				</table>
		</td>
	</tr>
</table>
<input type="hidden" value="1" name="FAIscript_posted" >
<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
<!--
	focus_field("cn","description");
-->
</script>


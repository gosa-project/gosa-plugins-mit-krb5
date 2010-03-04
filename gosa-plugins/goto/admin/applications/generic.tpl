<table summary="" style="width:100%;">
 <tr>
  <td style="width:50%;">

   <table summary="">
     <tr>
      <td><LABEL for="cn">{t}Application name{/t}{$must}</LABEL></td>
      <td>
{render acl=$cnACL}
	<input type='text' id="cn" name="cn" size=25 maxlength=60 value="{$cn}" title="{t}Application name{/t}">
{/render}
      </td>
    </tr>
    <tr>
     <td><LABEL for="gosaApplicationName">{t}Display name{/t}</LABEL></td>
     <td>
{render acl=$gosaApplicationNameACL}
        <input id="gosaApplicationName" name="gosaApplicationName" size=35 maxlength=60 
	  value="{$gosaApplicationName}" title="{t}Application name to be displayed (i.e. below icons){/t}">
{/render}
     </td>
    </tr>
    <tr>
     <td><LABEL for="gosaApplicationExecute">{t}Execute{/t}{$must}</LABEL></td>
     <td>
{render acl=$gosaApplicationExecuteACL}
        <input id="gosaApplicationExecute" name="gosaApplicationExecute" size=35 maxlength=120 
	  value="{$gosaApplicationExecute}" title="{t}Path and/or binary name of application{/t}">
{/render}
     </td>
    </tr>
    <tr>
     <td><LABEL for="description">{t}Description{/t}</LABEL></td>
     <td>
{render acl=$descriptionACL}
      <input type='text' id="description" name="description" size=35 maxlength=80 value="{$description}">
{/render}
     </td>
    </tr>
    <tr><td colspan=2><div style="height:15px;"></div></td></tr>
    <tr>
      <td><LABEL for="base">{t}Base{/t}{$must}</LABEL></td>
      <td>
{render acl=$baseACL}
       <select size="1" id="base" name="base" title="{t}Choose subtree to place application in{/t}" 
        {if $isReleaseApplikation} disabled {/if}>
        {html_options options=$bases selected=$base_select}
       </select>
{/render}
{if !$isReleaseApplikation}
{render acl=$baseACL disable_picture='images/lists/folder_grey.png'}
      <input type="image" name="chooseBase" src="images/lists/folder.png" class="center" title="{t}Select a base{/t}">
{/render}
{/if}
      </td>
     </tr>
   </table>
  </td>
  <td style="border-left:1px solid #A0A0A0">
   &nbsp;
  </td>
  <td style="vertical-align:top;">
   <table summary="">
    <tr>
    <td>
    <LABEL for="picture_file">{t}Icon{/t}</LABEL>
    <br>
{if $IconReadable}
    <img alt="" src="getbin.php?rand={$rand}" border=1 style="width:48px; height:48; background-color:white; vertical-align:bottom;">
{else}
	<img src='images/empty.png' style="width:48px; height:48; background-color:white; vertical-align:bottom;" border=1 >
{/if}
    </td>
    <td style="vertical-align:top">
    &nbsp;<br>

    <input type="hidden" name="MAX_FILE_SIZE" value="100000">
{render acl=$gosaApplicationIconACL}
    <input name="picture_file" type="file" size="20" maxlength="255" accept="image/*.png" id="picture_file">
{/render}
{render acl=$gosaApplicationIconACL}
<input type="submit" name="update" value="{t}Update{/t}" title="{t}Reload picture from LDAP{/t}">
{/render}
{render acl=$gosaApplicationIconACL}
<input type="submit" name="remove_picture" value="{t}Remove picture{/t}" title="{t}Remove picture from LDAP{/t}">
{/render}
    </td>
    </tr>
   </table>
  </td>
 </tr>
</table>

<p class="plugbottom" style="height:4px; margin-bottom:0px;">&nbsp;</p>

<h3>{t}Options{/t}</h3>
<table summary="" style="width:100%;">
  <tr>
    <td style="width:50%;border-right:1px solid #B0B0B0; vertical-align:top">
{render acl=$execForGroupmembersACL}
      <input type=checkbox name="execForGroupmembers" value="1" {$execForGroupmembers}>
{/render}
	{t}Only executable for members{/t}
      <br>
{render acl=$overwriteConfigACL}
      <input type=checkbox name="overwriteConfig" value="1" {$overwriteConfig}>
{/render}
	{t}Replace user configuration on startup{/t}
    </td>
    <td>
{render acl=$placeOnDesktopACL}
      <input type=checkbox name="placeOnDesktop" value="1" {$placeOnDesktop}>
{/render}
      {t}Place icon on members desktop{/t}
      <br>
{render acl=$placeInStartmenuACL}
      <input type=checkbox name="placeInStartmenu" value="1" {$placeInStartmenu}>
{/render}
      {t}Place entry in members startmenu{/t}
      <br>
{render acl=$placeOnKickerACL}
      <input type=checkbox name="placeOnKicker" value="1" {$placeOnKicker}>
{/render}
      {t}Place entry in members launch bar{/t}
    </td>
  </tr>
</table>

<p class="plugbottom" style="height:4px; margin-bottom:0px;">&nbsp;</p>

<table width="99%" summary="">
	<tr>
		<td>
			<h3>{t}Script{/t}</h3>
{render acl=$gotoLogonScriptACL}
			<textarea name="gotoLogonScript" style='width:99%;height:220px;'>{$gotoLogonScript}</textarea>
{/render}
{render acl=$gotoLogonScriptACL}
			<input type="file" name="ScriptFile" value="{t}Import{/t}">
{/render}
{render acl=$gotoLogonScriptACL}
			<input type="submit" name="upLoad" value="{t}Upload{/t}">
{/render}
			<input type='image' name='downloadScript'  src='images/save.png' title='{t}Download{/t}' class='center'>
		</td>
	</tr>
</table>

<div style="height:20px;"></div>

<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('cn');
  -->
</script>

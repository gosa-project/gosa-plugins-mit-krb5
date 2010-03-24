<table style='table-layout:fixed; width:100%; table-layout:auto;' summary="{t}Entry info{/t}">

<tr>
  <td>

   <table style='width:100%;' summary="{t}Entry info{/t}">


    <colgroup>
        <col width="32%">
        <col width="14%">
        <col width="14%">
        <col width="14%">
        <col width="14%">
        <col width="8%">
    </colgroup>
    <tr style="background-color: #E8E8E8; height:26px;font-weight:bold;">
     <td class="tbhead">{t}Name{/t}</td><td class="tbhead">{t}Phone{/t}</td><td class="tbhead">{t}Fax{/t}</td>
     <td class="tbhead">{t}Mobile{/t}</td><td class="tbhead">{t}Private{/t}</td><td class="tbrhead">{t}Contact{/t}</td>
    </tr>
    {$search_result}
   </table>

   <table style='text-align:center; width:100%;' summary="{t}Entry info{/t}">

    <tr>
     <td>{$range_selector}</td>
    </tr>
   </table>

   {if $show_info eq 1}
    {include file=$address_info}
   {/if}

  </td>
  <td style='width:270px;'>

   <div class="contentboxh" style="border-bottom:1px solid #B0B0B0;">
    <p class="contentboxh">{image path="{$infoimage}" align="right"}{t}Information{/t}
</p>
   </div>
   <div class="contentboxb">
    <p class="contentboxb">
     {t}The telephone list plugin provides list and search facilities for the people in your site. You may want to specify the asterisk [*] like in 'Go*us' to find 'Gonicus'. Use the filters below to narrow down your search.{/t}
    </p>
   </div>
   <br>
   <div class="contentboxh">
    <p class="contentboxh" style="vertical-align:middle;">{image path="{$actionimage}" align="right"}{t}Actions{/t}
</p>
   </div>
   <div class="contentboxb">
    <p class="contentboxb" style="vertical-align:middle;">
{if $internal_createable}
     {image path="{$add_image}"}&nbsp;

     <a href="main.php{$plug}&amp;global=add" style="text-align:center;vertical-align:middle;">{t}Add entry{/t}</a><br>
{/if}

{if $internal eq 0}
 {if $internal_editable}
     {image path="{$edit_image}"}&nbsp;

     <a href="main.php{$plug}&amp;global=edit">{t}Edit entry{/t}</a><br>
 {/if}
 {if $internal_removeable}
	     {image path="{$delete_image}"}&nbsp;

	     <a href="main.php{$plug}&amp;global=remove" style="vertical-align:middle;">{t}Remove entry{/t}</a><br>
 {/if}
{/if}
    </p>
   </div>
   <br>
   <div class="contentboxh">
    <p class="contentboxh">{image path="{$launchimage}" align="right"}{t}Filters{/t}
</p>
   </div>
   <div class="contentboxb">
    <table style='width:100%;' summary="{t}Entry info{/t}">

     {$alphabet}
    </table>
    
<table style='width:100%;' summary="{t}Entry info{/t}">

	<tr>
		<td>
<input type="checkbox" name="organizational" value="1" {$organizational} onClick="mainform.submit()" title="{t}Select to see regular users{/t}">{t}Show organizational entries{/t}<br>
    <input type="checkbox" name="global" value="1" {$global} onClick="mainform.submit()" title="{t}Select to see users in addressbook{/t}">{t}Show addressbook entries{/t}<br>
		</td>
	</tr>
</table>

<table style='width:100%;' summary="{t}Entry info{/t}">

	<tr>
		<td>
			<label for="search_base">{image path="{$tree_image}" title="{t}Display results for department{/t}"}
</label>
		</td>
    	<td>
			<select name="search_base" style='width:220px' onChange="mainform.submit()" title="{t}Choose the department the search will be based on{/t}" size=1>
		      	{html_options options=$deplist selected=$depselect}
				<option disabled>&nbsp;</option>
    		</select>
		</td>
	</tr>
</table>
<table style='width:100%;' summary="{t}Entry info{/t}">

	<tr>
		<td>
			<label for="object_type">{image path="{$obj_image}" title="{t}Match object{/t}"}
</label>
		</td>
	    <td>
			<select id="object_type" style='width:220px' name="object_type" onChange="mainform.submit()" title="{t}Choose the object that will be searched in{/t}" size=1>
    	   		{html_options options=$objlist selected=$object_type}
				<option disabled>&nbsp;</option>
	      	</select>
	    </td>
	</tr>
</table>
<table style='width:100%;' summary="{t}Entry info{/t}">

	<tr>
		<td><label for="search_for">{image path="{$search_image}" title="{t}Search for{/t}"}
</label>
		</td>
	    <td>
			<input id="search_for" style='width:99%' type='text' name='search_for' maxlength='20' value='{$search_for}' title='{t}Search string{/t}' onChange="mainform.submit()">
		</td>
	</tr>
</table>
   {$apply}
   </div>
  </td>
</tr>
</table>

<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('search_for');
  -->
</script>

{if $mode == "remove"}

<b>{t}Please select the objects you want to remove:{/t}</b>
<br>
<br>
<table>
{foreach from=$FAI_group item=item key=key}
	<tr>
		<td>
			{if $item.freezed}
				<img src="images/lists/locked.png" class='center'>
			{else}
				<input type='checkbox' name='{$mode}_{$key}'
    	     		{if $item.selected} checked {/if}>
			{/if}
		</td>
		<td>
			<img src='{$types.$key.IMG}' alt='{$types.$key.KZL}' title='{$types.$key.NAME}'
				class='center'>
		</td>
		<td style='width:150px;'>{$types.$key.NAME}</td>
		<td style='width:80px;'>{if $item.freezed}<i>({t}Freezed{/t})</i>{/if}</td>
		<td><i>({$item.description.0})</i></td>
	</tr>
{/foreach}
</table>

{elseif $mode == "edit"}

<b>{t}Select the object you want to edit:{/t}</b>
<br>
<br>
<table>
{foreach from=$FAI_group item=item key=key}
	<tr>
		<td>
	        <input type='radio' name='{$mode}_selected' value='{$key}'
               {if $item.selected} checked {/if}>
		</td>
		<td>
			<img src='{$types.$key.IMG}' alt='{$types.$key.KZL}' title='{$types.$key.NAME}'
				class='center'>
		</td>
		<td style='width:150px;'>{$types.$key.NAME}</td>
		<td><i>({$item.description.0})</i>
		</td>
	</tr>
{/foreach}
</table>

{elseif $mode == "copy"}

<b>{t}Select the object you want to copy:{/t}</b>
<br>
<br>
<table>
{foreach from=$FAI_group item=item key=key}
	<tr>
		<td>
			<input type='checkbox' name='{$mode}_{$key}'
    	   		{if $item.selected} checked {/if}>
		</td>
		<td>
			<img src='{$types.$key.IMG}' alt='{$types.$key.KZL}' title='{$types.$key.NAME}'
				class='center'>
		</td>
		<td style='width:150px;'>{$types.$key.NAME}</td>
		<td><i>({$item.description.0})</i>
		</td>
	</tr>
{/foreach}
</table>

{/if}
<br>
<br>
<input type='hidden' value='faiGroupHandle' name='faiGroupHandle'>
<p class='seperator'></div>
<div style='text-align:right; padding:5px'>
	<button type='submit' name='faiGroupHandle_apply'>{msgPool type=applyButton}</button>

	&nbsp;
	<button type='submit' name='faiGroupHandle_cancel'>{msgPool type=cancelButton}</button>

</div>

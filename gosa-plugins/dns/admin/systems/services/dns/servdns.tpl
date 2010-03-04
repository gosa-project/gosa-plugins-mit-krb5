{if $dns_take_over}
<table summary="" width="100%">
    <tr>
        <td style="width:100%;vertical-align:top;">
            <h3>{t}DNS take over initiated{/t}</h3>
            {$warning}
            {t}This includes 'all' DNS zones that are located within this server. Please double check if your really want to do this.{/t}
            <p>
            {$warning2}
            <br>
            <input type='submit' name='cancel_take_over' value='{msgPool type=cancelButton}'>
            </p>
            <p>
            {t}Following objects will be taken over{/t}&nbsp;:
            </p>
            <p>
            <pre>{$info}</pre>
            </p>
        </td>
    </tr>
</table>
{else}
<table summary="" width="100%">
{if $dns_server_list_cnt}
<tr>
    <td style="width:100%;vertical-align:top;">
        <b>{t}Take over DNS configuration from{/t}</b>&nbsp;
        <select name='take_over_src'>
            {html_options options=$dns_server_list}
        </select>
        <input type="submit" name="take_over" value="{t}Take over{/t}">
    </td>
</tr>
{/if}
<tr>
    <td style="width:100%;vertical-align:top;">
<h3>{t}Zones{/t}</h3>
		  {$ZoneList}
		  {if $is_createable}
		  <input type="submit" name="AddZone" value="{msgPool type=addButton}">
		  {else}
		  <input type="button" value="{msgPool type=addButton}" disabled>
		  {/if}
    </td>
</tr>
</table>


<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('AddZone');
  -->
</script>

{/if}
<hr>
<p>
<div style="width:100%; text-align:right;">
    <input type='submit' name='SaveService' value='{msgPool type=saveButton}'>
    &nbsp;
    <input type='submit' name='CancelService' value='{msgPool type=cancelButton}'>
</div>
</p>

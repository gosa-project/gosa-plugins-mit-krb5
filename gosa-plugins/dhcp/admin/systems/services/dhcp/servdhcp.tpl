{if $dns_take_over}
<table summary="" width="100%">
    <tr>
        <td style="width:100%;vertical-align:top;">
			<h3>{t}DHCP take over will take place when saving this entry. Choose 'Cancel' to abort.{/t}</h3>
        </td>
    </tr>
</table>
{else}
<table summary="" width="100%">
{if $dhcp_server_list_cnt}
<tr>
    <td style="width:100%;vertical-align:top;">
        <b>{t}Take over dhcp configuration from following server{/t}</b>&nbsp;
        <select name='take_over_src'>
            {html_options options=$dhcp_server_list}
        </select>
        <input type="submit" name="take_over" value="{msgPool type=applyButton}">
    </td>
</tr>
{/if}
<tr>
    <td style="width:100%;vertical-align:top;">
    <h3>{t}DHCP sections{/t}</h3>
        {$DhcpList}
    </td>
</tr>
</table>
{/if}
<p class='seperator'>&nbsp;</p>
<div style="width:100%; text-align:right;padding-top:10px;padding-bottom:3px;">
    <input type='submit' name='SaveService' value='{msgPool type=saveButton}'>
    &nbsp;
    <input type='submit' name='CancelService' value='{msgPool type=cancelButton}'>
</div

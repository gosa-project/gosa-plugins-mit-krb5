{* GOsa dhcp subnet - smarty template *}
<p><b>{t}Generic{/t}</b></p>
<table width="100%">
 <tr>
  <td width="50%">
   <table>
    <tr>
     <td>{t}Network address{/t}{$must}</td>
     <td>
{render acl=$acl}
		<input id='cn' type='text' name='cn' size='25' maxlength='80' value='{$cn}'>
{/render}
	</td>
    </tr>
    <tr>
     <td>{t}Netmask{/t}{$must}</td>
     <td>
{render acl=$acl}
		<input type='text' name='dhcp_netmask' size='25' maxlength='80' value='{$dhcp_netmask}'>
{/render}
	</tr>
   </table>
  </td>
  <td style='vertical-align:top'>
   <table>
    <tr>
     <td>
{render acl=$acl}
		<input type="checkbox" name="use_range" value="1" 
			onChange="changeState('range_start');changeState('range_stop');" {$use_range}></td>
{/render}
     <td>{t}Range for dynamic address assignment{/t}</td>
  </tr>
  <tr>
  <td>&nbsp;</td>
  <td>
{render acl=$acl}
	<input type='text' id='range_start' name='range_start' size='25' maxlength='80' value='{$range_start}' {$range_disabled}>
{/render}
  &nbsp;<b>-</b>&nbsp;
{render acl=$acl}
  <input type='text' id='range_stop' name='range_stop' size='25' maxlength='80' value='{$range_stop}' {$range_disabled}>
{/render}
  </td>
  </tr>
  </table>
  </td>
  </tr>
</table>
<input type='hidden' name='dhcp_subnet_posted' value='1'>
<hr>

<!-- Place cursor in correct field -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	 focus_field('cn');
  -->
</script>

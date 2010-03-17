{* GOsa dhcp sharedNetwork - smarty template *}
<p><b>{t}Generic{/t}</b></p>
<table width="100%" border="0">
 <tr>

  <td width="50%">

   <table>
    <tr>
     <td>{t}Name{/t}{$must}</td>
     <td>
{render acl=$acl}
      <input id='cn' type='text' name='cn' size='25' maxlength='80' value='{$cn}' title='{t}Name for shared network{/t}'>
{/render}
     </td>
    </tr>
    <tr>
     <td>{t}Server identifier{/t}</td>
     <td>
{render acl=$acl}
      <input type='text' name='server-identifier' size='25' maxlength='80' value='{$server_identifier}'
	title='{t}Propagated server identifier for this shared network{/t}'>
{/render}
     </td>
    </tr>
   </table>
  
  </td>
  
  <td>

   <table>
    <tr>
     <td>
{render acl=$acl}
      <input type=checkbox name="authoritative" value="1" {if $authoritative} checked {/if}
       title="{t}Select if this server is authoritative for this shared network{/t}">{t}Authoritative server{/t}
{/render}
     </td>
    </tr>
   </table>
  </td>
  
 </tr>
</table>

<hr>

<table width="100%">
 <tr>
  <td width="50%">
  
  <p><b>{t}Leases{/t}</b></p>
   <table>
    <tr>
     <td>{t}Default lease time{/t}</td>
     <td>
{render acl=$acl}
      <input type='text' name='default-lease-time' size='10' maxlength='25' value='{$default_lease_time}'
        title='{t}Default lease time{/t}'>&nbsp;{t}seconds{/t}
{/render}
     </td>
    </tr>
    <tr>
     <td>{t}Max. lease time{/t}</td>
     <td>
{render acl=$acl}
      <input type='text' name='max-lease-time' size='10' maxlength='25' value='{$max_lease_time}'
        title='{t}Maximum lease time{/t}'>&nbsp;{t}seconds{/t}
{/render}
     </td>
    </tr>
    <tr>
     <td>{t}Min. lease time{/t}</td>
     <td>
{render acl=$acl}
      <input type='text' name='min-lease-time' size='10' maxlength='25' value='{$min_lease_time}'
        title='{t}Minimum lease time{/t}'>&nbsp;{t}seconds{/t}
{/render}
     </td>
    </tr>
   </table>
   
  </td>

  <td>

   <p><b>{t}Access control{/t}</b></p>
   <table>
    <tr>
     <td>
{render acl=$acl}
     <input type=checkbox name="unknown-clients" value="1" {$allow_unknown_state}
        title="{t}Select if unknown clients should get dynamic IP addresses{/t}">{t}Allow unknown clients{/t}
{/render}
     </td>
    </tr>
    <tr>
     <td>
{render acl=$acl}
     <input type=checkbox name="bootp" value="1" {$allow_bootp_state}
        title="{t}Select if bootp clients should get dynamic IP addresses{/t}">{t}Allow bootp clients{/t}
{/render}
     </td>
    </tr>
    <tr>
     <td>
{render acl=$acl}
     <input type=checkbox name="booting" value="1" {$allow_booting_state}
        title="{t}Select if clients are allowed to boot using this DHCP server{/t}">{t}Allow booting{/t}
{/render}
     </td>
    </tr>
   </table>
  </td>
  
 </tr> 
</table>

<hr>

<!-- Place cursor in correct field -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
  document.mainform.cn.focus();
  -->
</script>

<div class="contentboxh">
 <p class="contentboxh">
  <img src="images/launch.png" align="right" alt="[F]">{t}Filter{/t}
 </p>
</div>

<div class="contentboxb">

<div style="border-top:1px solid #AAAAAA"></div>

 {$PRIMARY}&nbsp;<LABEL for='TEMPLATES'>{t}Show primary groups{/t}</LABEL><br>
 {$SAMBA}&nbsp;<LABEL for='TEMPLATES'>{t}Show samba groups{/t}</LABEL><br>
 {$MAIL}&nbsp;<LABEL for='TEMPLATES'>{t}Show mail groups{/t}</LABEL><br>

 {$SCOPE}

 <table summary='{t}Filter options{/t}' style="width:100%;border-top:1px solid #B0B0B0;">
  <tr>
   <td>
    <label for="NAME">
     <img src="images/lists/search.png" align=middle>&nbsp;Name
    </label>
   </td>
   <td>
    {$NAME}
   </td>
  </tr>
 </table>

 <table summary='{t}Filter options{/t}'  width="100%"  style="background:#EEEEEE;border-top:1px solid #B0B0B0;">
  <tr>
   <td width="100%" align="right">
    {$APPLY}
   </td>
  </tr>
 </table>
</div>

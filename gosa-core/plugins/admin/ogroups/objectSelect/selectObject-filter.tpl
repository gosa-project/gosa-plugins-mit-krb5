<div class="contentboxh">
 <p class="contentboxh">
  <img src="images/launch.png" align="right" alt="[F]">{t}Filter{/t}
 </p>
</div>

<div class="contentboxb">

<div style="border-top:1px solid #AAAAAA"></div>

{$DEPARTMENT}&nbsp;<LABEL for='DEPARTMENT'>{t}Show department{/t}</LABEL><br>
{$USER}&nbsp;<LABEL for='USER'>{t}Show users{/t}</LABEL><br>
{$GROUP}&nbsp;<LABEL for='GROUP'>{t}Show groups{/t}</LABEL><br>

{$SERVER}&nbsp;<LABEL for='SERVER'>{t}Show server{/t}</LABEL><br>
{$WORKSTATION}&nbsp;<LABEL for='WORKSTATION'>{t}Show workstation{/t}</LABEL><br>
{$TERMINAL}&nbsp;<LABEL for='TERMINAL'>{t}Show terminal{/t}</LABEL><br>

{$PRINTER}&nbsp;<LABEL for='PRINTER'>{t}Show printer{/t}</LABEL><br>
{$PHONE}&nbsp;<LABEL for='PHONE'>{t}Show phone{/t}</LABEL><br>

 <div style="border-top:1px solid #AAAAAA"></div>
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

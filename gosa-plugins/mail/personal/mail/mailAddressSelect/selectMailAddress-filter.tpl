<div class="contentboxh">
 <p class="contentboxh">
  {image path="images/launch.png" align="right"}{t}Filter{/t}

 </p>
</div>

<div class="contentboxb">

<div style="border-top:1px solid #AAAAAA"></div>

  {$USER}&nbsp;<LABEL for='SAMBA'>{t}Show users{/t}</LABEL><br>
  {$GROUP}&nbsp;<LABEL for='POSIX'>{t}Show groups{/t}</LABEL><br>

 <div style="border-top:1px solid #AAAAAA"></div>

 {$SCOPE}

 <table summary='{t}Filter options{/t}' style="width:100%;border-top:1px solid #B0B0B0;">
  <tr>
   <td>
    <label for="NAME">
     {image path="images/lists/search.png"}&nbsp;Name

    </label>
   </td>
   <td>
    {$NAME}
   </td>
  </tr>
 </table>

 <table summary='{t}Filter options{/t}' width="100%"  style="background:#EEEEEE;border-top:1px solid #B0B0B0;">
  <tr>
   <td width="100%" align="right">
    {$APPLY}
   </td>
  </tr>
 </table>
</div>

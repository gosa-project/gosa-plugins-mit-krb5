<table summary="" style="width:100%; vertical-align:top; text-align:left;" cellpadding=4>
 <tr>
   <td style="vertical-align:top; width:50%">
     <h3>{t}DFS Properties{/t}</h3>
     
     <table summary="">
      <tr>
       <td><LABEL for="sambaShareName">{t}Name of dfs Share{/t}</LABEL>{$must}</td>
       <td><input type='text' id="sambaShareName" name="sambaShareName" size=40 maxlength=100 value="{$sambasharename}"></td>
      </tr>
      <tr>
       <td><LABEL for="descripition">{t}Description{/t}</LABEL>{$must}</td>
       <td><input type='text' id="description" name="description" size=40 maxlength=100 value="{$sharedescription}"></td>
      </tr>
      <tr>
       <td><LABEL for="fileserver">{t}Fileserver{/t}</LABEL>{$must}</td>
       <td><input type='text' id="fileserver" name="fileserver" size=40 maxlength=100 value="{$fileserver}"></td>
      </tr>
      <tr>
       <td><LABEL for="fileservershare">{t}Share on Fileserver{/t}</LABEL>{$must}</td>
       <td><input type='text' id="fileservershare" name="fileservershare" size=40 maxlength=100 value="{$fileservershare}"></td>
      </tr>
     </table>

   </td>
   <td style="border-left:1px solid #A0A0A0">
    &nbsp;
   </td>
   <td style="vertical-align:top; width:50%">
     <h3>{t}DFS Location{/t}</h3>

     <table summary="" style="width:100%">
      <tr>
       <td><LABEL for="location">{t}Location{/t}</LABEL>{$must}</td>
       <td><input type='text' id="location" name="location" size=40 maxlength=100 value="{$location}"></td>
      </tr>
      <tr>
       <td><LABEL for="dfsdescription">{t}Description{/t}</LABEL></td>
       <td><input type='text' id="dfsdescription" name="dfsdescription" size=40 maxlength=100 value="{$dfsdescription}"></td>
      </tr>
     </table>

   </td>
 </tr>
</table>

<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('ou');
  -->
</script>

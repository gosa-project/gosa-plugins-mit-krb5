<table summary="" style="width:100%; vertical-align:top; text-align:left;" cellpadding=4>
  <tr>
    <td style="vertical-align:top;">
      <div class="contentboxh" style="height:20px;">
        <p class="contentboxh" style="font-size:12px">
          <b>
            <LABEL for="local_list">{t}Select addresses to add{/t}</LABEL> 
            {$hint}
          </b>
          <br>
        </p>
      </div>
      <div class="contentboxb">
        <p class="contentboxb" style="border-top:1px solid #B0B0B0;background-color:#F8F8F8">
          <select id="local_list" style="width:100%; margin-top:4px; height:450px;" name="local_list[]" size="15" multiple>
        	  {html_options options=$mailusers}
          </select>
        </p>
      </div>
    </td>
    <td style="vertical-align:top;width:350px">
      <div class="contentboxh" style="height:20px;">
        <p class="contentboxh" style="font-size:12px">
          {image path="{$launchimage}" align="right"}

          <b>{t}Filters{/t}</b>
        </p>
      </div>
      <div class="contentboxb" style="background-color:#F8F8F8">
        <table summary="" style="width:100%;border-top:1px solid #B0B0B0; background-color:#F8F8F8">
          {$alphabet}
        </table>
        <table summary="" width="100%" style="border-top:1px solid #B0B0B0;background-color:#F8F8F8">
          <tr>
            <td>
              <LABEL for="depselect">{t}Select department{/t}</LABEL>
              {image path="{$tree_image}"}&nbsp;

              <select id="depselect" name="depselect" size=1 onChange="mainform.submit()" 
                title="{t}Choose the department the search will be based on{/t}">
                      {html_options options=$deplist selected=$depselect}
                  </select>
            </td>
          </tr>
        </table>
    
        <table summary="" width="100%" style="border-top:1px solid #B0B0B0;background-color:#F8F8F8">
          <tr>
            <td style="width:18px">
              {image path="{$search_image}"}

            </td>
            <td>
              <input type='text' name='regex' maxlength='20' style="width:99%" value='{$regex}' 
                title='{t}Regular expression for matching addresses{/t}' onChange="mainform.submit()">
            </td>
          </tr>
        </table>

        <table summary="" width="100%" style="border-top:1px solid #B0B0B0;background-color:#F8F8F8">
          <tr>
            <td style="width:18px;">
              {image path="{$usearch_image}"}

            </td>
            <td>
              <input type='text' name='muser' maxlength='20' style="width:99%" value='{$muser}' 
                title='{t}User name of which addresses are shown{/t}' onChange="mainform.submit()">
            </td>
          </tr>
        </table>
        {$apply}
      </div>
    </td>
  </tr>
</table>

<p class="plugbottom">
  <button type='submit' name='add_locals_finish'>{msgPool type=addButton}</button>

  &nbsp;
  <button type='submit' name='add_locals_cancel'>{msgPool type=cancelButton}</button>

</p>
<!-- 
// vim:tabstop=2:expandtab:shiftwidth=2:filetype=php:syntax:ruler:
-->

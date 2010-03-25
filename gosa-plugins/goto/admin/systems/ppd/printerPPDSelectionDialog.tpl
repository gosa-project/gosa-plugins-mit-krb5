<table style='width:100%; ' summary="{t}PPD selection dialog{/t}">

	<tr>
		<td style='width=50%;'>

			<div class="contentboxh" style="height:20px;">
					<b>{t}Select objects to add{/t}</b>
			</div>
			<div class="contentboxb">
          {$List}
					<input type=hidden name="edit_helper">
			</div>
		</td>
		<td>

			<div class="contentboxh" style="height:20px;">
          {image path="{$launchimage}" align="right"}
          <b>{t}Filters{/t}</b>
      </div>
      <div class="contentboxb">

          {$alphabet}
        <table style='background-color:#F8F8F8' summary="{t}Filter options{/t}" width="100%">
          <tr>
            <td style="width:18px">
              {image path="{$search_image}" title="{t}Display objects matching{/t}"}

            </td>
            <td>
              <input type='text' style="width:99%" name='regex' maxlength='20' value='{$regex}' 
                title='{t}Regular expression for matching object names{/t}' onChange="mainform.submit();">
            </td>
          </tr>
        </table>
              {$apply}

      </div>
    </td>
  </tr>
</table>

<hr>
<div class="plugin-actions">
  <button type='submit' name='ClosePPDSelection'>{t}Close{/t}</button>

</div>
<!--
// vim:tabstop=2:expandtab:shiftwidth=2:filetype=php:syntax:ruler:
-->

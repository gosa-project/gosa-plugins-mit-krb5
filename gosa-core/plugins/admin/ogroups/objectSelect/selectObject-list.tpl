<table summary="" style="width:100%;height:100%" cellpadding=2>
  <tr>
    <td style="width:100%;">
      <div class="contentboxh">
        <p class="contentboxh">&nbsp;{$HEADLINE}&nbsp;{$SIZELIMIT}</p>
      </div>
      
      <div class="contentboxb">
       <div style='background:white;padding:0px;padding:3px;'>
        <table><tr>
          <td>{$ROOT}&nbsp;</td><td>{$BACK}&nbsp;</td><td>{$HOME}&nbsp;</td><td>{$RELOAD}&nbsp;</td><td>{$SEPARATOR}&nbsp;</td><td>{t}Base{/t} {$BASE}&nbsp;</td><td>{$SEPARATOR}&nbsp;</td><td><img src='images/rocket.png' alt='' class='center'></td><td> {$ACTIONS}</td>
        </tr></table>
       </div>
      </div>
      
      <div style='height:4px;'>
      </div>
      {$LIST}
    </td>
    <td style='min-width:250px'>
      {$FILTER}
    </td>
  </tr>
</table>


<p class='separator'>&nbsp;</p>
  <p style="text-align:right">
  <input type=submit name="objectSelect_save" value="{msgPool type=okButton}">
  &nbsp;
  <input type=submit name="objectSelect_cancel" value="{msgPool type=cancelButton}">
</p>

<input type="hidden" name="ignore">

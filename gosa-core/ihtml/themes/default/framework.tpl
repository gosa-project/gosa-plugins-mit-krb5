  <body>
   {$php_errors}
   <div class='title-bar'>
    <ul>
     <li>{$logo}</li>
     <li class='right table-wrapper'>
       <div class='logout-label'>
         <form action='logout.php' name='logoutframe' method='post' enctype='multipart/form-data'>
          <div style='cursor:pointer' title='{t}Log out{/t}' onClick="
                    return question('{t}You are currently editing a database entry. Do you want to dismiss the changes?{/t}',
            'logout.php?forcedlogout');">{image path="{$logoutimage}"}</div>
          <input type='hidden' name='forcedlogout' value='1'>
          <input type="hidden" name="php_c_check" value="1">
         </form>
       </div>
     </li>
     <li class='right table-wrapper'>
      <div class='logged-in-label'>{$loggedin}</div>
     </li>
     <li class='right table-wrapper'>
       <div class='logout-label'>
        <canvas id="sTimeout" width="22" height="22" title="{$sessionLifetime}|{t}Session expires in %d!{/t}"></canvas>
       </div>
     </li>
    </ul>
   </div>
   <form action='main.php{$plug}' id='mainform' name='mainform' method='post' enctype='multipart/form-data'>

   {if $hideMenus}

    {$contents}

   {else}

    {$menu}
    {$msg_dialogs}
    <div class='plugin-area'>
      {$pathMenu}
      {$contents}
    </div>
   {/if}

   {if $channel != ""}
   <input type="hidden" name="_channel_" value="{$channel}">
   {/if}

   {$errors}
   {$focus}
   <input type="hidden" name="php_c_check" value="1">
  </form>

  <!-- Automatic logout when session is expired -->
  <script type='text/javascript'>
   function logout()
   {
    document.location = 'logout.php';
   }
   logout.delay({$sessionLifetime});
  </script>     
 </body>
</html>

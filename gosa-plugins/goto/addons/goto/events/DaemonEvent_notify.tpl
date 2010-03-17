
{if $is_new}

<table style='width:100%;'>
  <tr>
    <td style='width:50%; padding:6px;' class='right-border'>

	  <b>{t}Message settings{/t}</b>
      <table style="width:100%;">
        <tr>
          <td>{t}Sender{/t}</td>
          <td><input type='text' name="from" value="{$from}" style="width:100%;"></td>
        </tr>
        <tr>
          <td>{t}Subject{/t}</td>
          <td><input type='text' name="subject" value="{$subject}" style="width:100%;"></td>
        </tr>
        <tr>
          <td colspan="2">{t}Message{/t} :</td>
        </tr>
        <tr>
          <td colspan="2" >
            <textarea style="width:99%;height:250px;" name="message" >{$message}</textarea>
          </td>
        </tr>
      </table>
    </td>
    <td style='width:50%; '>

	    <b>{t}Schedule{/t}</b>
      <table>
        <tr>
          <td colspan="2">{$timestamp}
<br><br></td>
        </tr>
	  </table>
      <table style='width:100%;'>
        <tr>
          <td style="width:50%;">
            <b>{t}Target users{/t}</b>
            <br>
			<select style="height:180px;width:100%" name="user[]"  multiple size=4>
				{html_options options=$user}
			</select>
          </td>
          <td>
            <b>{t}Target groups{/t}</b>
            <br>
			<select style="height:180px;width:100%" name="group[]"  multiple size=4>
				{html_options options=$group}
			</select>
          </td>
        </tr>
		<tr>
			<td colspan="2">
				<button type='submit' name='open_target_list'>{$add_str}</button>

				<button type='submit' name='del_any_target'>{$del_str}</button>

			</td>
		</tr>
      </table>
    </td>
  </tr>
</table>

{else}

<table style='width:100%;'>
	<tr>
		<td>

			<table>
				<tr>
					<td>{t}ID{/t}</td>
					<td>{$data.ID}</td>
				</tr>
				<tr>
					<td>{t}Status{/t}</td>
					<td>{$data.STATUS}</td>
				</tr>
				<tr>
					<td>{t}Result{/t}</td>
					<td>{$data.RESULT}</td>
				</tr>
				<tr>
					<td>{t}Target{/t}</td>
					<td>{$data.MACADDRESS}</td>
				</tr>
				<tr>
					<td>{t}Timestamp{/t}
</td>
					<td>{$timestamp}</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

{/if}

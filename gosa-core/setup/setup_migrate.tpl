<div>
    <div class='default'>

	{if $method == "default"}
			<p>{t}During the LDAP inspection, we're going to check for several common pitfalls that may occur when migration to GOsa base LDAP administration. You may want to fix the problems below, in order to provide smooth services.{/t}
			</p>

			{foreach from=$checks item=val key=key}
				<div style='width:98%; padding:4px; background-color:{cycle values="#F0F0F0, #FFF"}'>

			{if $checks.$key.ERROR_MSG}
                                <!-- Add ability to display info popup -->
                                <div class='step2_entry_container_info'>
                        {else}
                                <!-- Normal entry everything is fine -->
                                <div class='step2_entry_container'>
                        {/if}
				<div class='step2_entry_name'><b>{$checks.$key.TITLE}</b></div>
				<div class='step2_entry_status'>
				{if $checks.$key.STATUS}
					<div class='step2_successful'>{$checks.$key.STATUS_MSG}</div>
				{else}
					<div class='step2_failed'>{$checks.$key.STATUS_MSG}</div>
				{/if}
				</div>
					{if $checks.$key.ERROR_MSG}
						{$checks.$key.ERROR_MSG}
					{/if}
				</div>
				</div>
			{/foreach}
		<br>
		<button type='submit' name='reload'>{t}Check again{/t}</button>


		{elseif $method == "rootOC_migrate_dialog"}

			<h2>{t}Add required object classes to the LDAP base{/t}</h2>

			<b>{t}Current{/t}</b>
			<div class="step2_entry_container_info">
				<div style='padding-left:20px;'>
					<pre>{$details.current}</pre>
				</div>
			</div>
			<br>
			<b>{t}After migration{/t}</b>
			<div class="step2_entry_container_info">
				<div style='padding-left:20px;'>
					<pre>{$details.target}</pre>
				</div>
			</div>

			<br>
			<button type='submit' name='rootOC_migrate_start'>{t}Migrate{/t}</button>

			</p>
				

			<hr>	
			<div style='width:100%; text-align:right; padding:5px;'>
				<button type='submit' name='rootOC_dialog_cancel'>{t}Close{/t}</button>

			</div>

		{elseif $method == "outside_winstations"}

			<h2>{t}Move windows workstations into a valid windows workstation department{/t}</h2>

			{t}This dialog allows you to move the displayed windows workstations into a valid department{/t}
			<br>
			{t}Be careful with this tool, there may be references pointing to this workstations that can't be migrated.{/t}
			<br>
			<br>	

			{foreach from=$outside_winstations item=val key=key}
				{if $outside_winstations.$key.selected}
					<input id='select_winstation_{$key}' type='checkbox' name='select_winstation_{$key}' checked>
				{else}
					<input id='select_winstation_{$key}' type='checkbox' name='select_winstation_{$key}'>
				{/if}

				&nbsp;{$outside_winstations.$key.dn}
				{if $outside_winstations.$key.ldif != ""}
                    <div class="step2_entry_container_info" id="sol_8">
						<div style='padding-left:20px;'>
							<pre>
								{$outside_winstations.$key.ldif}
							</pre>
						</div>
					</div>
				{/if}
				<br>
			{/foreach}
			<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^select_winstation_','toggle_calue')">
			{t}Select all{/t}
			<p>
			<b>{t}Move selected windows workstations into the following GOsa department{/t} : </b>
			<select name='move_winstation_to' size=1>
				{html_options options=$ous}
			</select>
			<br>
			<button type='submit' name='outside_winstations_dialog_perform'>{t}Move selected workstations{/t}</button>

			<button type='submit' name='outside_winstations_dialog_whats_done'>{t}What will be done here{/t}</button>

			</p>
				

			<hr>	
			<div style='width:100%; text-align:right; padding:5px;'>
				<button type='submit' name='outside_winstations_dialog_cancel'>{t}Close{/t}</button>

			</div>
		

		{elseif $method == "outside_groups"}

			<h2>{t}Move groups into configured group tree{/t}</h2>

                        <p>
                        {t}This dialog allows moving a couple of groups to the configured group tree. Doing this may straighten your LDAP service.{/t}
                        </p>
                        <p style='color:red'>
                        {t}Be careful with this option! There may be references pointing to these groups. The GOsa setup can't migrate references, so you may want to cancel the migration in this case.{/t}
                        </p>
			<p>
			{t}Move selected groups into this group tree{/t}: 
			<select name='move_group_to' size=1>
				{html_options options=$ous}
			</select>
			</p>

			{foreach from=$outside_groups item=val key=key}
				{if $outside_groups.$key.selected}
					<input id='select_group_{$key}' type='checkbox' name='select_group_{$key}' checked>
				{else}
					<input id='select_group_{$key}' type='checkbox' name='select_group_{$key}'>
				{/if}

				&nbsp;{$outside_groups.$key.dn}
				{if $outside_groups.$key.ldif != "" && $group_details}
                      <div class="step2_entry_container_info" id="sol_8">
<div style='padding-left:20px;'>
<pre>
{$outside_groups.$key.ldif}
</pre>
</div>
</div>
				{/if}
				<br>
			{/foreach}

			<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^select_group_','toggle_calue')">
			{t}Select all{/t}
			<br>
			<p>
                        {if $group_details}
                        <button type='submit' name='outside_groups_dialog_refresh'>{t}Hide changes{/t}</button>

                        {else}
                        <button type='submit' name='outside_groups_dialog_whats_done'>{t}Show changes{/t}</button>

                        {/if}
			</p>

			<hr>	
			<div style='width:99%; text-align:right; padding:5px;'>
				<button type='submit' name='outside_groups_dialog_perform'>{t}Apply{/t}</button>

				&nbsp;
				<button type='submit' name='outside_groups_dialog_cancel'>{t}Cancel{/t}</button>

			</div>
		
		{elseif $method == "outside_users"}

			<h2>{t}Move users into configured user tree{/t}</h2>
			<p>
			{t}This dialog allows moving a couple of users to the configured user tree. Doing this may straighten your LDAP service.{/t}
			</p>
			<p style='color:red'>
			{t}Be careful with this option! There may be references pointing to these users. The GOsa setup can't migrate references, so you may want to cancel the migration in this case.{/t}
			</p>	
			<p>
			{t}Move selected users into this people tree{/t}: 
			<select name='move_user_to' size=1>
				{html_options options=$ous}
			</select>
			</p>
			{foreach from=$outside_users item=val key=key}
				{if $outside_users.$key.selected}
					<input id='select_user_{$key}' type='checkbox' name='select_user_{$key}' checked>
				{else}
					<input id='select_user_{$key}' type='checkbox' name='select_user_{$key}'>
				{/if}

				&nbsp;{$outside_users.$key.dn}
				{if $outside_users.$key.ldif != "" && $user_details}
                      <div class="step2_entry_container_info" id="sol_8">
<div style='padding-left:20px;'>
<pre>
{$outside_users.$key.ldif}
</pre>
</div>
</div>
				{/if}
				<br>
			{/foreach}
			<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^select_user_','toggle_calue')">
			{t}Select all{/t}
			<br>

			{if $user_details}
			<button type='submit' name='outside_users_dialog_refresh'>{t}Hide changes{/t}</button>

                        {else}
			<button type='submit' name='outside_users_dialog_whats_done'>{t}Show changes{/t}</button>

			{/if}

			<hr>	
			<div style='width:99%; text-align:right; padding:5px;'>
				<button type='submit' name='outside_users_dialog_perform'>{t}Apply{/t}</button>

				&nbsp;
				<button type='submit' name='outside_users_dialog_cancel'>{t}Cancel{/t}</button>

			</div>
		

		{elseif $method == "migrate_acls"}
			<h2>{t}Migrate GOsa 2.5 administrative accounts{/t}</h2>
            <p>
            {t}This dialog allows the migration of GOsa 2.5 admin accounts into GOsa 2.6 useable accounts.{/t}
            </p>
			<table>	
				<tr>	
					<td></td>
					<td></td>
				</tr>
			{foreach from=$migrateable_users item=item key=key}
				<tr>
					<td><input type='checkbox' name='migrate_admin_{$key}' value='{$key}' {if $item.checked} checked {/if}></td>
					<td>{$item.dn}</td>
				</tr>
			{/foreach}
			</table>

			{if !$details}
				<button type='submit' name='migrate_acls_show_changes'>{t}Show changes{/t}</button>

				<input type='hidden' name='details' value='0'>
			{else}
				<input type='hidden' name='details' value='1'>

				<br>
				<div class="step2_entry_container_info">
				{t}Current{/t}
				<div style='padding-left:20px;'>
					<pre>{$migrate_acl_base_entry}</pre>
				</div>
				{t}After migration{/t}
				<div style='padding-left:20px;'>
					<pre>{$migrate_acl_base_entry}{foreach from=$migrateable_users item=item key=key}{if $item.checked}<b>{$item.details}</b>{/if}{/foreach}</pre>
				</div>
				</div>
				<br>
				<button type='submit' name='migrate_acls_hide_changes'>{t}Hide changes{/t}</button>

			{/if}

			<button type='submit' name=''>{t}Reload{/t}</button>

			<hr>	
			<div style='width:99%; text-align:right; padding:5px;'>
				<button type='submit' name='migrate_admin_user'>{t}Apply{/t}</button>	

				<button type='submit' name='migrate_acls_cancel'>{t}Cancel{/t}</button>

			</div>

		{elseif $method == "create_acls"}

		{if $acl_create_selected != "" && $what_will_be_done_now!=""}
			<div>
<pre>
{$what_will_be_done_now}
</pre>
			</div>		
			<button type='submit' name='create_acls_create_confirmed'>{t}Next{/t}</button>

			<button type='submit' name='create_acls_create_abort'>{t}Abort{/t}</button>

		{else}
			<h2>{t}Create a new GOsa administrator account{/t}</h2>
	
			<p>
			{t}This dialog will automatically add a new super administrator to your LDAP tree.{/t}
			</p>
			<table>
				<tr>
					<td>
						{t}Name{/t}:&nbsp;
					</td>
					<td>
						<i>System administrator</i>
					</td>
				</tr>
				<tr>
					<td>
						{t}User ID{/t}:&nbsp;
					</td>
					<td>
						<input type='text' value='{$new_user_uid}' name='new_user_uid'><br>
					</td>
				</tr>
				<tr>
					<td>
						{t}Password{/t}:&nbsp;
					</td>
					<td>
						<input type='password' value='{$new_user_password}' name='new_user_password'><br>
					</td>
				</tr>
				<tr>
					<td>
						{t}Password (again){/t}:&nbsp;
					</td>
					<td>

						<input type='password' value='{$new_user_password2}' name='new_user_password2'><br>
					</td>
				</tr>
			</table>
	
<!-- Place cursor -->
<script language="JavaScript" type="text/javascript">
  <!-- // First input field on page
	focus_field('new_user_password');
  -->
</script>

			<hr>	
			<div style='width:99%; text-align:right; padding:5px;'>
				<button type='submit' name='create_admin_user'>{t}Apply{/t}</button>	

				<button type='submit' name='create_acls_cancel'>{t}Cancel{/t}</button>

			</div>
			{/if}	
		{elseif $method == "migrate_deps"}
	
			<h2>Department migration</h2>

			<p>{t}The listed departments are currently invisible in the GOsa user interface. If you want to change this for a couple of entries, select them and use the migrate button below.{/t}</p>
			<p>{t}If you want to know what will be done when migrating the selected entries, use the 'Show changes' button to see the LDIF.{/t}</p>
					
			{foreach from=$deps_to_migrate item=val key=key}

				{if $deps_to_migrate.$key.checked}
					<input id='migrate_{$key}' type='checkbox' name='migrate_{$key}' checked>
					{$deps_to_migrate.$key.dn}
					{if $deps_to_migrate.$key.after != ""}
						<div class="step2_entry_container_info" id="sol_8">

{t}Current{/t}
<div style='padding-left:20px;'>
<pre>
dn: {$deps_to_migrate.$key.dn}
{$deps_to_migrate.$key.before}
</pre>
</div>
{t}After migration{/t}
<div style='padding-left:20px;'>
<pre>
dn: {$deps_to_migrate.$key.dn}
{$deps_to_migrate.$key.after}
</pre>
</div>
						</div>
					{/if}
				{else}
					<input id='migrate_{$key}' type='checkbox' name='migrate_{$key}'>
					{$deps_to_migrate.$key.dn}
				{/if}
				
			<br>
			{/foreach}
			<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^migrate_','toggle_calue')">
			{t}Select all{/t}
			<br>

			{if $deps_details}
			<button type='submit' name='deps_visible_migrate_refresh'>{t}Hide changes{/t}</button>

			{else}
			<button type='submit' name='deps_visible_migrate_whatsdone'>{t}Show changes{/t}</button>

			{/if}

			<hr>	

			<div style='width:99%; text-align:right; padding:5px;'>
				<button type='submit' name='deps_visible_migrate_migrate'>{t}Apply{/t}</button>

				&nbsp;
				<button type='submit' name='deps_visible_migrate_close'>{t}Cancel{/t}</button>

			</div>
		{elseif $method == "migrate_users"}
	
			<h2>User migration</h2>

			<p>{t}The listed users are currently invisible in the GOsa user interface. If you want to change this for a couple of users, just select them and use the 'Migrate' button below.{/t}</p>
			<p>{t}If you want to know what will be done when migrating the selected entries, use the 'Show changes' button to see the LDIF.{/t}</p>
			{foreach from=$users_to_migrate item=val key=key}

				{if $users_to_migrate.$key.checked}
					<input type='checkbox' name='migrate_{$key}' checked id='migrate_{$key}'>
					{$users_to_migrate.$key.dn}
					{if $users_to_migrate.$key.after != ""}
						<div class="step2_entry_container_info" id="sol_8">

{t}Current{/t}
<div style='padding-left:20px;'>
<pre>
dn: {$users_to_migrate.$key.dn}
{$users_to_migrate.$key.before}
</pre>
</div>
{t}After migration{/t}
<div style='padding-left:20px;'>
<pre>
dn: {$users_to_migrate.$key.dn}
{$users_to_migrate.$key.after}
</pre>
</div>
						</div>
					{/if}
				{else}
					<input type='checkbox' name='migrate_{$key}' id='migrate_{$key}'>
					{$users_to_migrate.$key.dn}
				{/if}
				<br>
			{/foreach}
			<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^migrate_','toggle_calue')">
			{t}Select all{/t}
			<br>

			{if $user_details}
			<button type='submit' name='users_visible_migrate_refresh'>{t}Hide changes{/t}</button>

			{else}
			<button type='submit' name='users_visible_migrate_whatsdone'>{t}Show changes{/t}</button>

			{/if}

			<hr>	

			<div style='width:99%; text-align:right; padding-top:5px;'>
				<button type='submit' name='users_visible_migrate_migrate'>{t}Apply{/t}</button>

				&nbsp;
				<button type='submit' name='users_visible_migrate_close'>{t}Cancel{/t}</button>

			</div>


	{elseif $method == "devices"}


			<h2>Devices</h2>

			<p>{t}The listed devices are currently invisible in the GOsa interface. If you want to change this for a couple of devices, just select them and use the 'Migrate' button below.{/t}</p>
			<p>{t}If you want to know what will be done when migrating the selected entries, use the 'Show changes' button to see the LDIF.{/t}</p>
		{foreach from=$devices item=item key=key}
           	<input type='checkbox' name='migrate_{$key}' id='migrate_{$key}' {if $item.DETAILS} checked {/if}>
				<b>{$item.DEVICE_NAME}</b>
				 - {$item.DN} 

				{if $item.DETAILS && $device_details}
					<div class="step2_entry_container_info">
						<b>{t}Current{/t}</b>
						<pre>{$item.CURRENT}</pre>
	
						
						<b>{t}After migration{/t}</b>
						<pre>{$item.AFTER}</pre>
					</div>
				{/if}
			<br>
		{/foreach}
		<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^migrate_','toggle_calue')">
		{t}Select all{/t}
	
		<br>

		{if $device_details}
			<button type='submit' name='device_dialog_refresh'>{t}Hide changes{/t}</button>

			<button type='submit' name='dummy_11'>{t}Refresh{/t}</button>

		{else}
			<button type='submit' name='device_dialog_whats_done'>{t}Show changes{/t}</button>

		{/if}

		<hr>	

		<div style='width:99%; text-align:right; padding-top:5px;'>
			<button type='submit' name='migrate_devices'>{t}Apply{/t}</button>

			&nbsp;
			<button type='submit' name='device_dialog_cancel'>{t}Cancel{/t}</button>

		</div>

	{elseif $method == "services"}


			<h2>Services</h2>

			<p>{t}The listed services are currently invalid for the GOsa version you are going to install. If you want to update a couple of service, just select them and use the 'Migrate' button below.{/t}</p>
			<p>{t}If you want to know what will be done when migrating the selected entries, use the 'Show changes' button to see the LDIF.{/t}</p>
		{foreach from=$services item=item key=key}
           	<input type='checkbox' name='migrate_{$key}' id='migrate_{$key}' {if $item.DETAILS} checked {/if}>
				<b>{$item.DN}</b>

				{if $item.DETAILS && $service_details}
					<div class="step2_entry_container_info">
						<b>{t}Current{/t}</b>
						<pre>{$item.CURRENT}</pre>
	
						
						<b>{t}After migration{/t}</b>
						<pre>{$item.AFTER}</pre>
					</div>
				{/if}
			<br>
		{/foreach}
		<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^migrate_','toggle_calue')">
		{t}Select all{/t}
	
		<br>

		{if $service_details}
			<button type='submit' name='service_dialog_refresh'>{t}Hide changes{/t}</button>

			<button type='submit' name='dummy_11'>{t}Refresh{/t}</button>

		{else}
			<button type='submit' name='service_dialog_whats_done'>{t}Show changes{/t}</button>

		{/if}

		<hr>	

		<div style='width:99%; text-align:right; padding-top:5px;'>
			<button type='submit' name='migrate_services'>{t}Apply{/t}</button>

			&nbsp;
			<button type='submit' name='service_dialog_cancel'>{t}Cancel{/t}</button>

		</div>


	{elseif $method == "menus"}


			<h2>Application menus</h2>

			<p>{t}The listed menus are currently invisible in the GOsa interface. If you want to change this for a couple of devices, just select them and use the 'Migrate' button below.{/t}</p>
			<p>{t}If you want to know what will be done when migrating the selected entries, use the 'Show changes' button to see the LDIF.{/t}</p>
		{foreach from=$menus item=item key=key}
           	<input type='checkbox' name='migrate_{$key}' id='migrate_{$key}' {if $item.DETAILS} checked {/if}>
				<b>{$item.DN}</b>

				{if $item.DETAILS && $menu_details}
					<div class="step2_entry_container_info">
						<b>{t}Current{/t}</b>
						<pre>{$item.CURRENT}</pre>
	
						
						<b>{t}After migration{/t}</b>
						<pre>{$item.AFTER}</pre>
					</div>
				{/if}
			<br>
		{/foreach}
		<input type='checkbox' id='toggle_calue' onClick="toggle_all_('^migrate_','toggle_calue')">
		{t}Select all{/t}
	
		<br>

		{if $menu_details}
			<button type='submit' name='menu_dialog_refresh'>{t}Hide changes{/t}</button>

			<button type='submit' name='dummy_11'>{t}Refresh{/t}</button>

		{else}
			<button type='submit' name='menu_dialog_whats_done'>{t}Show changes{/t}</button>

		{/if}

		<hr>	

		<div style='width:99%; text-align:right; padding-top:5px;'>
			<button type='submit' name='migrate_menus'>{t}Apply{/t}</button>

			&nbsp;
			<button type='submit' name='menu_dialog_cancel'>{t}Cancel{/t}</button>

		</div>
	{/if}
    </div>
</div>

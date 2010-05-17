<div>
    <div class='default'>
	<p>
	{t}This seems to be the first time you start GOsa - we didn't find any configuration right now. This simple wizard intends to help you while setting it up.{/t}
	</p>
	
	<p style='border-top:1px solid #AAAAAA; padding-top:10px;'>
	<b>{t}What will the wizard do for you?{/t}</b>
	</p>
	<ul>
	 <li>{t}Create a basic, single site configuration{/t}</li>
	 <li>{t}Tries to find problems within your PHP and LDAP setup{/t}</li>
	</ul>
	<p>
	<b>{t}What will the wizard NOT do for you?{/t}</b>
	</p>
	<ul>
	 <li>{t}Find every possible configuration error{/t}</li>
	 <li>{t}Migrate every possible LDAP setup - create backup dumps!{/t}</li>
	</ul>

	<p style='border-top:1px solid #AAAAAA; padding-top:10px;'>
	<b>{t}To continue...{/t}</b>
	</p>
	<p>
	{t}For security reasons you need to authenticate for the installation by creating the file '/tmp/gosa.auth', containing the current session ID on the servers local filesystem. This can be done by executing the following command:{/t}
	</p>
	<tt>
	echo -n <b>{$auth_id}</b> &gt; {$path}
	</tt>
	<p>
	{t}Click the 'Continue' button when you've finished.{/t}
	</p>
     </div>
</div>

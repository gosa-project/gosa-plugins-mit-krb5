package gosaTriggered;
use Exporter;
@ISA = qw(Exporter);
my @events = (
    "get_events", 
    "get_login_usr_for_client",
    "get_client_for_login_usr",
    "gen_smb_hash",
    "trigger_reload_ldap_config",
    "ping",
    "network_completition",
    "set_activated_for_installation",
    "new_key_for_client",
    "detect_hardware",
    "get_login_usr",
    "get_login_client",
    "trigger_action_localboot",
    "trigger_action_faireboot",
    "trigger_action_reboot",
    "trigger_action_activate",
    "trigger_action_lock",
    "trigger_action_halt",
    "trigger_action_update", 
    "trigger_action_reinstall",
    "trigger_action_memcheck", 
    "trigger_action_sysinfo",
    "trigger_action_instant_update",
    "trigger_action_rescan",
    "trigger_action_wake",
    "recreate_fai_server_db",
    "recreate_fai_release_db",
    "recreate_packages_list_db",
    "send_user_msg", 
    "get_available_kernel",
	"trigger_activate_new",
    );
@EXPORT = @events;

use strict;
use warnings;
use GOSA::GosaSupportDaemon;
use Data::Dumper;
use Crypt::SmbHash;
use Net::ARP;
use Net::Ping;
use Socket;
use Time::HiRes qw( usleep);

BEGIN {}

END {}

### Start ######################################################################

#&main::read_configfile($main::cfg_file, %cfg_defaults);

sub get_events {
    return \@events;
}

sub send_user_msg {

# msg from gosa
# <xml><header>gosa_send_user_msg</header><source>GOSA</source><target>GOSA</target>
# <timestamp>20080429151605</timestamp>
# <users>andreas.rettenberger</users>
# <subject>hallo</subject>
# <message>test</message>
# <macaddress>GOSA</macaddress>
# </xml>

    my ($msg, $msg_hash, $session_id) = @_ ;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];

    #my $subject = &decode_base64(@{$msg_hash->{'subject'}}[0]);
    my $subject = @{$msg_hash->{'subject'}}[0];
    my $from = @{$msg_hash->{'from'}}[0];
    my @users = @{$msg_hash->{'users'}};
	my @groups = @{$msg_hash->{'groups'}}[0];
    my $delivery_time = @{$msg_hash->{'delivery_time'}}[0];
    #my $message = &decode_base64(@{$msg_hash->{'message'}}[0]);
    my $message = @{$msg_hash->{'message'}}[0];
    
    # keep job queue uptodate if necessary 
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    # error handling
    if (not $delivery_time =~ /^\d{14}$/) {
        my $error_string = "delivery_time '$delivery_time' is not a valid timestamp, please use format 'yyyymmddhhmmss'";
        &main::daemon_log("$session_id ERROR: $error_string", 1);
        return &create_xml_string(&create_xml_hash($header, $target, $source, $error_string));
    }

    # add incoming message to messaging_db
    my $new_msg_id = 1;
	my $new_msg_id_sql = "SELECT MAX(CAST(id AS INTEGER)) FROM $main::messaging_tn";
    my $new_msg_id_res = $main::messaging_db->exec_statement($new_msg_id_sql);
    if (defined @{@{$new_msg_id_res}[0]}[0] ) {
        $new_msg_id = int(@{@{$new_msg_id_res}[0]}[0]);
        $new_msg_id += 1;
    }

	# highlight user name and group name
	my @receiver_l;
	@users = map(push(@receiver_l, "u_$_"), @users);
	#@groups = map(push(@receiver_l, "g_$_"), @groups);
# TODO
# handling, was passiert wenn in einer liste nix drin steht
# handling von groups hinzufügen
	

    my $func_dic = {table=>$main::messaging_tn,
        primkey=>[],
        id=>$new_msg_id,
        subject=>$subject,
        message_from=>$from,
        message_to=>join(",", @receiver_l),
        flag=>"n",
        direction=>"in",
        delivery_time=>$delivery_time,
        message=>$message,
        timestamp=>&get_time(),
    };
    my $res = $main::messaging_db->add_dbentry($func_dic);
    if (not $res == 0) {
        &main::daemon_log("$session_id ERROR: gosaTriggered.pm: cannot add message to message_db: $res", 1);
    } else {
        &main::daemon_log("$session_id INFO: gosaTriggered.pm: message with subject '$subject' successfully added to message_db", 5);
    }

    return;
}

#sub send_user_msg_OLD {
#    my ($msg, $msg_hash, $session_id) = @_ ;
#    my @out_msg_l;
#    my @user_list;
#    my @group_list;
#
#    my $header = @{$msg_hash->{'header'}}[0];
#    my $source = @{$msg_hash->{'source'}}[0];
#    my $target = @{$msg_hash->{'target'}}[0];
#    my $message = @{$msg_hash->{'message'}}[0];
#    if( exists $msg_hash->{'user'} ) { @user_list = @{$msg_hash->{'user'}}; }
#    if( exists $msg_hash->{'group'} ) { @group_list = @{$msg_hash->{'group'}}; }
#
#    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
#    if( defined $jobdb_id) {
#        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
#        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
#        my $res = $main::job_db->exec_statement($sql_statement);
#    }
#
#    # error handling
#    if( not @user_list && not @group_list ) {
#        &main::daemon_log("$session_id WARNING: no user-tag or a group-tag specified in 'send_user_msg'", 3); 
#        return ("<xml><header>$header</header><source>GOSA</source><target>GOSA</target>".
#                "<error_string>no user-tag or a group-tag specified in 'send_user_msg'</error_string></xml>");
#    }
#    if( not defined $message ) {
#        &main::daemon_log("$session_id WARNING: no message-tag specified in 'send_user_msg'", 3); 
#        return ("<xml><header>$header</header><source>GOSA</source><target>GOSA</target>".
#                "<error_string>no message-tag specified in 'send_user_msg'</error_string></xml>");
#
#    }
#
#    # resolve groups to users
#    my $ldap_handle = &main::get_ldap_handle($session_id);
#    if( @group_list ) {
#        if( not defined $ldap_handle ) {
#            &main::daemon_log("$session_id ERROR: cannot connect to ldap", 1);
#            return ();
#        } 
#        foreach my $group (@group_list) {   # Perform search
#            my $mesg = $ldap_handle->search( 
#                    base => $main::ldap_base,
#                    scope => 'sub',
#                    attrs => ['memberUid'],
#                    filter => "(&(objectClass=posixGroup)(cn=$group)(memberUid=*))");
#            if($mesg->code) {
#                &main::daemon_log($mesg->error, 1);
#                return ();
#            }
#            my $entry= $mesg->entry(0);
#            my @users= $entry->get_value("memberUid");
#            foreach my $user (@users) { push(@user_list, $user); }
#        }
#    }
#
#    # drop multiple users in @user_list
#    my %seen = ();
#    foreach my $user (@user_list) {
#        $seen{$user}++;
#    }
#    @user_list = keys %seen;
#
#    # build xml messages sended to client where user is logged in
#    foreach my $user (@user_list) {
#        my $sql_statement = "SELECT * FROM $main::login_users_tn WHERE user='$user'"; 
#        my $db_res = $main::login_users_db->select_dbentry($sql_statement);
#
#        if(0 == keys(%{$db_res})) {
#
#        } else {
#            while( my($hit, $content) = each %{$db_res} ) {
#                my $out_hash = &create_xml_hash('send_user_msg', $main::server_address, $content->{'client'});
#                &add_content2xml_hash($out_hash, 'message', $message);
#                &add_content2xml_hash($out_hash, 'user', $user);
#                if( exists $msg_hash->{'jobdb_id'} ) { 
#                    &add_content2xml_hash($out_hash, 'jobdb_id', @{$msg_hash->{'jobdb_id'}}[0]); 
#                }
#                my $out_msg = &create_xml_string($out_hash);
#                push(@out_msg_l, $out_msg);
#            }
#        }
#    }
#
#    return @out_msg_l;
#}


sub recreate_fai_server_db {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $out_msg;

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    $main::fai_server_db->create_table("new_fai_server", \@main::fai_server_col_names);
    &main::create_fai_server_db("new_fai_server",undef,"dont", $session_id);
    $main::fai_server_db->move_table("new_fai_server", $main::fai_server_tn);
    
    my @out_msg_l = ( $out_msg );
    return @out_msg_l;
}


sub recreate_fai_release_db {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $out_msg;

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7);
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    $main::fai_release_db->create_table("new_fai_release", \@main::fai_release_col_names);
    &main::create_fai_release_db("new_fai_release", $session_id);
    $main::fai_release_db->move_table("new_fai_release", $main::fai_release_tn);

    my @out_msg_l = ( $out_msg );
    return @out_msg_l;
}


sub recreate_packages_list_db {
	my ($msg, $msg_hash, $session_id) = @_ ;
	my $out_msg;

	my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
	if( defined $jobdb_id) {
		my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
		&main::daemon_log("$session_id DEBUG: $sql_statement", 7);
		my $res = $main::job_db->exec_statement($sql_statement);
	}

	&main::create_packages_list_db;

	my @out_msg_l = ( $out_msg );
	return @out_msg_l;
}


sub get_login_usr_for_client {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $client = @{$msg_hash->{'client'}}[0];

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    $header =~ s/^gosa_//;

    my $sql_statement = "SELECT * FROM known_clients WHERE hostname='$client' OR macaddress LIKE '$client'";
    my $res = $main::known_clients_db->select_dbentry($sql_statement);

    my $out_msg = "<xml><header>$header</header><source>$target</source><target>$source</target>";
    $out_msg .= &db_res2xml($res);
    $out_msg .= "</xml>";

    my @out_msg_l = ( $out_msg );
    return @out_msg_l;
}


sub get_client_for_login_usr {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my $usr = @{$msg_hash->{'usr'}}[0];
    $header =~ s/^gosa_//;

    my $sql_statement = "SELECT * FROM known_clients WHERE login LIKE '%$usr%'";
    my $res = $main::known_clients_db->select_dbentry($sql_statement);

    my $out_msg = "<xml><header>$header</header><source>$target</source><target>$source</target>";
    $out_msg .= &db_res2xml($res);
    $out_msg .= "</xml>";
    my @out_msg_l = ( $out_msg );
    return @out_msg_l;

}


sub ping {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $header = @{$msg_hash->{header}}[0];
    my $target = @{$msg_hash->{target}}[0];
    my $source = @{$msg_hash->{source}}[0];

    my ($sql, $res);
    my $out_msg = $msg;
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    # send message
    $sql = "SELECT * FROM $main::known_clients_tn WHERE ((hostname='$target') || (macaddress LIKE '$target'))"; 
    $res = $main::known_clients_db->exec_statement($sql);
    my $host_name = @{@$res[0]}[0];
    my $host_key = @{@$res[0]}[2];

    my $client_hash = &create_xml_hash("ping", $main::server_address, $host_name);
    &add_content2xml_hash($client_hash, 'session_id', $session_id); 
    my $client_msg = &create_xml_string($client_hash);
    my $error = &main::send_msg_to_target($client_msg, $host_name, $host_key, $header, $session_id);
    #if ($error != 0) {}

    my $message_id;
    while (1) {
        $sql = "SELECT * FROM $main::incoming_tn WHERE headertag='answer_$session_id'";
        $res = $main::incoming_db->exec_statement($sql);
        if (ref @$res[0] eq "ARRAY") { 
            $message_id = @{@$res[0]}[0];
            last;
        }
        usleep(100000);
    }
    my $answer_xml = @{@$res[0]}[3];
    my %data = ( 'answer_xml'  => 'bin noch da' );
    my $answer_msg = &build_msg("got_ping", $target, $source, \%data);
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    if (defined $forward_to_gosa) {
        $answer_msg =~s/<\/xml>/<forward_to_gosa>$forward_to_gosa<\/forward_to_gosa><\/xml>/;
    }

    $sql = "DELETE FROM $main::incoming_tn WHERE id=$message_id"; 
    $res = $main::incoming_db->exec_statement($sql);

    my @answer_msg_l = ( $answer_msg );
    return @answer_msg_l;
}



sub gen_smb_hash {
     my ($msg, $msg_hash, $session_id) = @_ ;
     my $source = @{$msg_hash->{source}}[0];
     my $target = @{$msg_hash->{target}}[0];
     my $password = @{$msg_hash->{password}}[0];

     my %data= ('hash' => join(q[:], ntlmgen $password));
     my $out_msg = &build_msg("gen_smb_hash", $target, $source, \%data );
     my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
     if (defined $forward_to_gosa) {
         $out_msg =~s/<\/xml>/<forward_to_gosa>$forward_to_gosa<\/forward_to_gosa><\/xml>/;
     }

     return ( $out_msg );
}


sub network_completition {
     my ($msg, $msg_hash, $session_id) = @_ ;
     my $source = @{$msg_hash->{source}}[0];
     my $target = @{$msg_hash->{target}}[0];
     my $name = @{$msg_hash->{hostname}}[0];

     # Can we resolv the name?
     my %data;
     if (inet_aton($name)){
	     my $address = inet_ntoa(inet_aton($name));
	     my $p = Net::Ping->new('tcp');
	     my $mac= "";
	     if ($p->ping($address, 1)){
	       $mac = Net::ARP::arp_lookup("", $address);
	     }

	     %data= ('ip' => $address, 'mac' => $mac);
     } else {
	     %data= ('ip' => '', 'mac' => '');
     }

     my $out_msg = &build_msg("network_completition", $target, $source, \%data );
     my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
     if (defined $forward_to_gosa) {
         $out_msg =~s/<\/xml>/<forward_to_gosa>$forward_to_gosa<\/forward_to_gosa><\/xml>/;
     }

     return ( $out_msg );
}


sub detect_hardware {
    my ($msg, $msg_hash, $session_id) = @_ ;
    # just forward msg to client, but dont forget to split off 'gosa_' in header
    my $source = @{$msg_hash->{source}}[0];
    my $target = @{$msg_hash->{target}}[0];
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my $out_hash = &create_xml_hash("detect_hardware", $source, $target);
    if( defined $jobdb_id ) { 
        &add_content2xml_hash($out_hash, 'jobdb_id', $jobdb_id); 
    }
    my $out_msg = &create_xml_string($out_hash);

    my @out_msg_l = ( $out_msg );
    return @out_msg_l;

}


sub trigger_reload_ldap_config {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $target = @{$msg_hash->{target}}[0];

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

	my $out_msg = &ClientPackages::new_ldap_config($target, $session_id);
	my @out_msg_l = ( $out_msg );

    return @out_msg_l;
}


sub set_activated_for_installation {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{header}}[0];
    my $source = @{$msg_hash->{source}}[0];
    my $target = @{$msg_hash->{target}}[0];
	my @out_msg_l;

	# update status of job 
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

	# create set_activated_for_installation message for delivery
    my $out_hash = &create_xml_hash("set_activated_for_installation", $source, $target);
    if( defined $jobdb_id ) { 
        &add_content2xml_hash($out_hash, 'jobdb_id', $jobdb_id); 
    }
    my $out_msg = &create_xml_string($out_hash);
	push(@out_msg_l, $out_msg); 

    return @out_msg_l;
}


sub trigger_action_faireboot {
    my ($msg, $msg_hash, $session_id) = @_;
    my $macaddress = @{$msg_hash->{target}}[0];
    my $source = @{$msg_hash->{source}}[0];

    my @out_msg_l;
    $msg =~ s/<header>gosa_trigger_action_faireboot<\/header>/<header>trigger_action_faireboot<\/header>/;
    push(@out_msg_l, $msg);

    &main::change_goto_state('locked', \@{$msg_hash->{target}}, $session_id);
	&main::change_fai_state('install', \@{$msg_hash->{target}}, $session_id); 

    # delete all jobs from jobqueue which correspond to fai
    my $sql_statement = "DELETE FROM $main::job_queue_tn WHERE (macaddress='$macaddress' AND ".
        "status='processing')";
    $main::job_db->del_dbentry($sql_statement ); 
                                             
    return @out_msg_l;
}


sub trigger_action_lock {
    my ($msg, $msg_hash, $session_id) = @_;
    my $macaddress = @{$msg_hash->{target}}[0];
    my $source = @{$msg_hash->{source}}[0];

    &main::change_goto_state('locked', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }
                                             
    my @out_msg_l;
    return @out_msg_l;
}


sub trigger_action_activate {
    my ($msg, $msg_hash, $session_id) = @_;
    my $macaddress = @{$msg_hash->{target}}[0];
    my $source = @{$msg_hash->{source}}[0];

    &main::change_goto_state('active', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }
                                             
    my $out_hash = &create_xml_hash("set_activated_for_installation", $source, $macaddress);
    if( exists $msg_hash->{'jobdb_id'} ) { 
        &add_content2xml_hash($out_hash, 'jobdb_id', @{$msg_hash->{'jobdb_id'}}[0]); 
    }
    my $out_msg = &create_xml_string($out_hash);

    return ( $out_msg );
}


sub trigger_action_localboot {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_localboot<\/header>/<header>trigger_action_localboot<\/header>/;
    &main::change_fai_state('localboot', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_halt {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_halt<\/header>/<header>trigger_action_halt<\/header>/;

    &main::change_fai_state('halt', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_reboot {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_reboot<\/header>/<header>trigger_action_reboot<\/header>/;

    &main::change_fai_state('reboot', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_memcheck {
    my ($msg, $msg_hash, $session_id) = @_ ;
    $msg =~ s/<header>gosa_trigger_action_memcheck<\/header>/<header>trigger_action_memcheck<\/header>/;

    &main::change_fai_state('memcheck', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_reinstall {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_reinstall<\/header>/<header>trigger_action_reinstall<\/header>/;

    &main::change_fai_state('reinstall', \@{$msg_hash->{target}}, $session_id);

    my %data = ( 'macAddress'  => \@{$msg_hash->{target}} );
    my $wake_msg = &build_msg("trigger_wake", "GOSA", "KNOWN_SERVER", \%data);
    my @out_msg_l = ($wake_msg, $msg);  
    return @out_msg_l;
}


sub trigger_action_update {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_update<\/header>/<header>trigger_action_update<\/header>/;

    &main::change_fai_state('update', \@{$msg_hash->{target}}, $session_id);

    my %data = ( 'macAddress'  => \@{$msg_hash->{target}} );
    my $wake_msg = &build_msg("trigger_wake", "GOSA", "KNOWN_SERVER", \%data);
    my @out_msg_l = ($wake_msg, $msg);  
    return @out_msg_l;
}


sub trigger_action_instant_update {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_instant_update<\/header>/<header>trigger_action_instant_update<\/header>/;

    &main::change_fai_state('update', \@{$msg_hash->{target}}, $session_id);

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my %data = ( 'macAddress'  => \@{$msg_hash->{target}} );
    my $wake_msg = &build_msg("trigger_wake", "GOSA", "KNOWN_SERVER", \%data);
    my @out_msg_l = ($wake_msg, $msg);  
    return @out_msg_l;
}


sub trigger_action_sysinfo {
    my ($msg, $msg_hash, $session_id) = @_;
    $msg =~ s/<header>gosa_trigger_action_sysinfo<\/header>/<header>trigger_action_sysinfo<\/header>/;

    &main::change_fai_state('sysinfo', \@{$msg_hash->{target}}, $session_id);
    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }

    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub new_key_for_client {
    my ($msg, $msg_hash, $session_id) = @_;

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }
    
    $msg =~ s/<header>gosa_new_key_for_client<\/header>/<header>new_key<\/header>/;
    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_rescan {
    my ($msg, $msg_hash, $session_id) = @_;

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }


    $msg =~ s/<header>gosa_trigger_action_rescan<\/header>/<header>trigger_action_rescan<\/header>/;
    my @out_msg_l = ($msg);  
    return @out_msg_l;
}


sub trigger_action_wake {
    my ($msg, $msg_hash, $session_id) = @_;

    my $jobdb_id = @{$msg_hash->{'jobdb_id'}}[0];
    if( defined $jobdb_id) {
        my $sql_statement = "UPDATE $main::job_queue_tn SET status='processed' WHERE id=jobdb_id";
        &main::daemon_log("$session_id DEBUG: $sql_statement", 7); 
        my $res = $main::job_db->exec_statement($sql_statement);
    }


    my %data = ( 'macAddress'  => \@{$msg_hash->{target}} );
    my $out_msg = &build_msg("trigger_wake", "GOSA", "KNOWN_SERVER", \%data);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l;
}


sub get_available_kernel {
        my ($msg, $msg_hash, $session_id) = @_;

        my $source = @{$msg_hash->{'source'}}[0];
        my $target = @{$msg_hash->{'target'}}[0];
        my $release= @{$msg_hash->{'release'}}[0];

        my @kernel;
        # Get Kernel packages for release
        my $sql_statement = "SELECT * FROM $main::packages_list_tn WHERE distribution='$release' AND package LIKE 'linux\-image\-%'";
        my $res_hash = $main::packages_list_db->select_dbentry($sql_statement);
        my %data;
        my $i=1;

        foreach my $package (keys %{$res_hash}) {
                $data{"answer".$i++}= $data{"answer".$i++}= ${$res_hash}{$package}->{'package'};
        }
        $data{"answer".$i++}= "default";

        my $out_msg = &build_msg("get_available_kernel", $target, $source, \%data);
        my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
        if (defined $forward_to_gosa) {
            $out_msg =~s/<\/xml>/<forward_to_gosa>$forward_to_gosa<\/forward_to_gosa><\/xml>/;
        }

        return ( $out_msg );
}


sub trigger_activate_new {
	my ($msg, $msg_hash, $session_id) = @_;

	my $source = @{$msg_hash->{'source'}}[0];
	my $target = @{$msg_hash->{'target'}}[0];
	my $header= @{$msg_hash->{'header'}}[0];
	my $mac= (defined($msg_hash->{'mac'}))?@{$msg_hash->{'mac'}}[0]:undef;
	my $ogroup= (defined($msg_hash->{'ogroup'}))?@{$msg_hash->{'ogroup'}}[0]:undef;
	my $timestamp= (defined($msg_hash->{'timestamp'}))?@{$msg_hash->{'timestamp'}}[0]:undef;
	my $base= (defined($msg_hash->{'base'}))?@{$msg_hash->{'base'}}[0]:undef;
	my $hostname= (defined($msg_hash->{'fqdn'}))?@{$msg_hash->{'fqdn'}}[0]:undef;
	my $ip_address= (defined($msg_hash->{'ip'}))?@{$msg_hash->{'ip'}}[0]:undef;
	my $dhcp_statement= (defined($msg_hash->{'dhcp'}))?@{$msg_hash->{'dhcp'}}[0]:undef;
	my $jobdb_id= (defined($msg_hash->{'jobdb_id'}))?@{$msg_hash->{'jobdb_id'}}[0]:undef;

	my $ldap_handle = &main::get_ldap_handle();
	my $ldap_entry;
	my $ogroup_entry;
	my $changed_attributes_counter = 0;
	
	eval {

		my $ldap_mesg= $ldap_handle->search(
			base => $main::ldap_base,
			scope => 'sub',
			filter => "(&(objectClass=gosaGroupOfnames)(cn=$ogroup))",
		);
		if($ldap_mesg->count == 1) {
			$ogroup_entry= $ldap_mesg->pop_entry();
		} elsif ($ldap_mesg->count == 0) {
			&main::daemon_log("ERROR: A GosaGroupOfNames with cn '$ogroup' was not found in base '".$main::ldap_base."'!", 1);
		} else {
			&main::daemon_log("ERROR: More than one ObjectGroups with cn '$ogroup' was found in base '".$main::ldap_base."'!", 1);
		}

		# build the base, use optional base parameter or take it from ogroup
		if(!(defined($base) && (length($base) > 0))) {
				# Subtract the ObjectGroup cn
				$base = $1 if $ogroup_entry->dn =~ /cn=$ogroup,ou=groups,(.*)$/;
		}

		# prepend ou=systems
		$base = "ou=systems,".$base;

		# Search for an existing entry (should be in ou=incoming)
		$ldap_mesg= $ldap_handle->search(
			base => $main::ldap_base,
			scope => 'sub',
			filter => "(&(objectClass=GOhard)(|(macAddress=$mac)(dhcpHWaddress=$mac)))",
		);

		# TODO: Find a way to guess an ip address for hosts with no ldap entry (MAC->ARP->IP)

		if($ldap_mesg->count == 1) {
			&main::daemon_log("DEBUG: One system with mac address '$mac' was found in base '".$main::ldap_base."'!", 6);
			# Get the entry from LDAP
			$ldap_entry= $ldap_mesg->pop_entry();

			if(!($ldap_entry->dn() eq "cn=".$ldap_entry->get_value('cn').",$base")) {
				# Move the entry to the new ou
				$ldap_entry->changetype('moddn');
				$ldap_entry->add(
					newrdn => "cn=".$ldap_entry->get_value('cn'),
					deleteoldrdn => 1,
					newsuperior => $base,
				);
			}

		} 

		$ldap_mesg= $ldap_handle->search(
			base => $main::ldap_base,
			scope => 'sub',
			filter => "(&(objectClass=GOhard)(|(macAddress=$mac)(dhcpHWaddress=$mac)))",
		);

		# TODO: Find a way to guess an ip address for hosts with no ldap entry (MAC->ARP->IP)

		if($ldap_mesg->count == 1) {
			$ldap_entry= $ldap_mesg->pop_entry();
			# Check for needed objectClasses
			my $oclasses = $ldap_entry->get_value('objectClass', asref => 1);
			foreach my $oclass ("FAIobject", "GOhard") {
				if(!(scalar grep $_ eq $oclass, map {$_ => 1} @$oclasses)) {
					&main::daemon_log("Adding objectClass $oclass", 1);
					$ldap_entry->add(
						objectClass => $oclass,
					);
					my $oclass_result = $ldap_entry->update($ldap_handle);
				}
			}

			# Set FAIstate
			if(defined($ldap_entry->get_value('FAIstate'))) {
				if(!($ldap_entry->get_value('FAIstate') eq 'install')) {
					$ldap_entry->replace(
						'FAIstate' => 'install'
					);
					my $replace_result = $ldap_entry->update($ldap_handle);
				}
			} else {
				$ldap_entry->add(
					'FAIstate' => 'install'
				);
				my $add_result = $ldap_entry->update($ldap_handle);
			}


		} elsif ($ldap_mesg->count == 0) {
			# TODO: Create a new entry
			# $ldap_entry = Net::LDAP::Entry->new();
			# $ldap_entry->dn("cn=$mac,$base");
			&main::daemon_log("WARNING: No System with mac address '$mac' was found in base '".$main::ldap_base."'! Re-queuing job.", 4);
			$main::job_db->exec_statement("UPDATE jobs SET status = 'waiting', timestamp = '".&get_time()."' WHERE id = $jobdb_id");
		} else {
			&main::daemon_log("ERROR: More than one system with mac address '$mac' was found in base '".$main::ldap_base."'!", 1);
		}

		# Add to ObjectGroup
		if(!(scalar grep $_, map {$_ => 1} $ogroup_entry->get_value('member', asref => 1))) {
			$ogroup_entry->add (
				'member' => $ldap_entry->dn(),
			);
			my $ogroup_result = $ogroup_entry->update($ldap_handle);
			if ($ogroup_result->code() != 0) {
				&main::daemon_log("ERROR: Updating the ObjectGroup '$ogroup' failed (code '".$ogroup_result->code()."') with '".$ogroup_result->{'errorMessage'}."'!", 1);
			}
		}

		# Finally set gotoMode to active
		if(defined($ldap_entry->get_value('gotoMode'))) {
			if(!($ldap_entry->get_value('gotoMode') eq 'active')) {
				$ldap_entry->replace(
					'gotoMode' => 'active'
				);
				my $activate_result = $ldap_entry->update($ldap_handle);
				if ($activate_result->code() != 0) {
					&main::daemon_log("ERROR: Activating system '".$ldap_entry->dn()."' failed (code '".$activate_result->code()."') with '".$activate_result->{'errorMessage'}."'!", 1);
				}
			}
		} else {
			$ldap_entry->add(
				'gotoMode' => 'active'
			);
			my $activate_result = $ldap_entry->update($ldap_handle);
			if ($activate_result->code() != 0) {
				&main::daemon_log("ERROR: Activating system '".$ldap_entry->dn()."' failed (code '".$activate_result->code()."') with '".$activate_result->{'errorMessage'}."'!", 1);
			}
		}
	};
	if($@) {
		&main::daemon_log("ERROR: activate_new failed with '$@'!", 1);
	}

	# Delete job
	$main::job_db->exec_statement("DELETE FROM jobs WHERE id =  $jobdb_id");

	# create set_activated_for_installation message for delivery
    my $out_hash = &create_xml_hash("set_activated_for_installation", $source, $target);
    my $out_msg = &create_xml_string($out_hash);
	my @out_msg_l = ($out_msg);

    return @out_msg_l;
}


1;

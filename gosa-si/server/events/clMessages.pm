package clMessages;
use Exporter;
@ISA = qw(Exporter);
my @events = (
    "PROGRESS",
    "FAIREBOOT",
    "TASKSKIP",
    "TASKBEGIN",
    "TASKEND",
    "TASKERROR",
    "HOOK",
    "GOTOACTIVATION",
    "LOGIN",
    "LOGOUT",
    "CURRENTLY_LOGGED_IN",
    );
@EXPORT = @events;

use strict;
use warnings;
use Data::Dumper;
use GOSA::GosaSupportDaemon;
use utf8;


BEGIN {}

END {}

### Start ######################################################################

my $ldap_uri;
my $ldap_base;
my $ldap_admin_dn;
my $ldap_admin_password;

my %cfg_defaults = (
"server" => {
   "ldap-uri" => [\$ldap_uri, ""],
   "ldap-base" => [\$ldap_base, ""],
   "ldap-admin-dn" => [\$ldap_admin_dn, ""],
   "ldap-admin-password" => [\$ldap_admin_password, ""],
   },
);
&read_configfile($main::cfg_file, %cfg_defaults);


sub get_events {
    return \@events;
}


sub read_configfile {
    my ($cfg_file, %cfg_defaults) = @_;
    my $cfg;

    if( defined( $cfg_file) && ( length($cfg_file) > 0 )) {
        if( -r $cfg_file ) {
            $cfg = Config::IniFiles->new( -file => $cfg_file );
        } else {
            &main::daemon_log("ERROR: clMessages.pm couldn't read config file!", 1);
        }
    } else {
        $cfg = Config::IniFiles->new() ;
    }
    foreach my $section (keys %cfg_defaults) {
        foreach my $param (keys %{$cfg_defaults{ $section }}) {
            my $pinfo = $cfg_defaults{ $section }{ $param };
            ${@$pinfo[0]} = $cfg->val( $section, $param, @$pinfo[1] );
        }
    }
}


sub LOGIN {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $login = @{$msg_hash->{$header}}[0];

    my %add_hash = ( table=>$main::login_users_tn, 
        primkey=> ['client', 'user'],
        client=>$source,
        user=>$login,
        timestamp=>&get_time,
        ); 
    my ($res, $error_str) = $main::login_users_db->add_dbentry( \%add_hash );
    if ($res != 0)  {
        &main::daemon_log("ERROR: cannot add entry to known_clients: $error_str");
        return;
    }

    return;   
}

# TODO umstellen wie bei LOGIN
sub LOGOUT {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $login = @{$msg_hash->{$header}}[0];

    my $sql_statement = "SELECT * FROM known_clients WHERE hostname='$source'";
    my $res = $main::known_clients_db->select_dbentry($sql_statement);
    if( 1 != keys(%$res) ) {
        &main::daemon_log("DEBUG: clMessages.pm: LOGOUT: no or more hits found in known_clients_db for host '$source'");
        return;
    }

    my $act_login = $res->{'1'}->{'login'};
    $act_login =~ s/$login,?//gi;

    if( $act_login eq "" ){ $act_login = "nobody"; }

    $sql_statement = "UPDATE known_clients SET login='$act_login' WHERE hostname='$source'";
    $res = $main::known_clients_db->update_dbentry($sql_statement);
    
    return;
}


sub CURRENTLY_LOGGED_IN {
    my ($msg, $msg_hash, $session_id) = @_;
    my ($sql_statement, $db_res);
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $login = @{$msg_hash->{$header}}[0];

    $sql_statement = "SELECT * FROM $main::login_users_tn WHERE client='$source'"; 
    $db_res = $main::login_users_db->select_dbentry($sql_statement);
    my %currently_logged_in_user = (); 
    while( my($hit_id, $hit) = each(%{$db_res}) ) {
        $currently_logged_in_user{$hit->{'user'}} = 1;
    }
    &main::daemon_log("DEBUG: logged in users from login_user_db: ".join(", ", keys(%currently_logged_in_user)), 7); 

    my @logged_in_user = split(/\s+/, $login);
    &main::daemon_log("DEBUG: logged in users reported from client: ".join(", ", @logged_in_user), 7); 
    foreach my $user (@logged_in_user) {
        my %add_hash = ( table=>$main::login_users_tn, 
                primkey=> ['client', 'user'],
                client=>$source,
                user=>$user,
                timestamp=>&get_time,
                ); 
        my ($res, $error_str) = $main::login_users_db->add_dbentry( \%add_hash );
        if ($res != 0)  {
            &main::daemon_log("ERROR: cannot add entry to known_clients: $error_str");
            return;
        }

        delete $currently_logged_in_user{$user};
    }

    # if there is still a user in %currently_logged_in_user 
    # although he is not reported by client 
    # then delete it from $login_user_db
    foreach my $obsolete_user (keys(%currently_logged_in_user)) {
        &main::daemon_log("WARNING: user '$obsolete_user' is currently not logged ".
                "in at client '$source' but still found at login_user_db", 3); 
        my $sql_statement = "DELETE FROM $main::login_users_tn WHERE client='$source' AND user='$obsolete_user'"; 
        my $res =  $main::login_users_db->del_dbentry($sql_statement);
        &main::daemon_log("WARNING: delete user '$obsolete_user' at client '$source' from login_user_db", 3); 
    }

    return;
}


sub GOTOACTIVATION {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l; 
}


sub PROGRESS {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_progress_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l; 
}


sub FAIREBOOT {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l; 
}


sub TASKSKIP {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l; 
}



sub TASKBEGIN {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  

# -----------------------> Update hier
#  <CLMSG_TASKBEGIN>finish</CLMSG_TASKBEGIN>
#  <header>CLMSG_TASKBEGIN</header>
# macaddress auslesen, Client im LDAP lokalisieren
# FAIstate auf "localboot" setzen, wenn FAIstate "install" oder "softupdate" war

    return @out_msg_l; 
}


sub TASKEND {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  

# -----------------------> Update hier
#  <CLMSG_TASKBEGIN>finish</CLMSG_TASKBEGIN>
#  <header>CLMSG_TASKBEGIN</header>
# macaddress auslesen, Client im LDAP lokalisieren
# FAIstate auf "error" setzen

    return @out_msg_l; 
}


sub TASKERROR {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  

# -----------------------> Update hier
#  <CLMSG_TASKBEGIN>finish</CLMSG_TASKBEGIN>
#  <header>CLMSG_TASKBEGIN</header>
# macaddress auslesen, Client im LDAP lokalisieren
# FAIstate auf "error" setzen

    return @out_msg_l; 
}


sub HOOK {
    my ($msg, $msg_hash, $session_id) = @_;
    my $out_msg = &build_status_result_update_msg($msg_hash);
    my @out_msg_l = ($out_msg);  
    return @out_msg_l; 
}


sub build_status_result_update_msg {
    my ($msg_hash) = @_;

    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'target'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $macaddress = @{$msg_hash->{'macaddress'}}[0];

    # test whether content is an empty hash or a string which is required
    my $content = @{$msg_hash->{$header}}[0];
    eval{
        if( 0 == keys(%$content) ) {
            $content = "";
        }
    };
    if( $@ ) {
        $content = " $content";
    }

    $header =~ s/CLMSG_//g;
    my $out_msg = sprintf("<xml> ".  
        "<header>gosa_update_status_jobdb_entry</header> ".
        "<source>%s</source> ".
        "<target>%s</target>".
        "<where> ".
            "<clause> ".
                "<phrase> ".
                    "<status>processing</status> ".
                    "<macaddress>%s</macaddress> ".
                "</phrase> ".
            "</clause> ".
        "</where> ".
        "<update> ".
            "<status>processing</status> ".
            "<result>%s</result> ".
        "</update> ".
        "</xml>", $source, "JOBDB", $macaddress, $header.$content);
    return $out_msg;
}   


sub build_progress_update_msg {
    my ($msg_hash) = @_;

    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'target'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $macaddress = @{$msg_hash->{'macaddress'}}[0];

    # test whether content is an empty hash or a string which is required
    my $content = @{$msg_hash->{$header}}[0];
    eval{
        if( 0 == keys(%$content) ) {
            $content = "";
        }
    };
    if( $@ ) {
        $content = "$content";
    }

    $header =~ s/CLMSG_//g;
    my $out_msg = sprintf("<xml> ".  
        "<header>gosa_update_status_jobdb_entry</header> ".
        "<source>%s</source> ".
        "<target>%s</target>".
        "<where> ".
            "<clause> ".
                "<phrase> ".
                    "<status>processing</status> ".
                    "<macaddress>%s</macaddress> ".
                "</phrase> ".
            "</clause> ".
        "</where> ".
        "<update> ".
            "<progress>%s</progress> ".
        "</update> ".
        "</xml>", $source, "JOBDB", $macaddress, $content);
    return $out_msg;
}


sub build_result_update_msg {
    my ($msg_hash) = @_;

    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'target'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $macaddress = @{$msg_hash->{'macaddress'}}[0];

    # test whether content is an empty hash or a string which is required
    my $content = @{$msg_hash->{$header}}[0];
    eval{
        if( 0 == keys(%$content) ) {
            $content = "";
        }
    };
    if( $@ ) {
        $content = " $content";
    }

    $header =~ s/CLMSG_//g;
    my $out_msg = sprintf("<xml> ".  
        "<header>gosa_update_status_jobdb_entry</header> ".
        "<source>%s</source> ".
        "<target>%s</target>".
        "<where> ".
            "<clause> ".
                "<phrase> ".
                    "<status>processing</status> ".
                    "<macaddress>%s</macaddress> ".
                "</phrase> ".
            "</clause> ".
        "</where> ".
        "<update> ".
            "<result>%s</result> ".
        "</update> ".
        "</xml>", $source, "JOBDB", $macaddress, $header.$content);
    return $out_msg;
}


1;

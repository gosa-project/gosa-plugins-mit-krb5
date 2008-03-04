package corefunctions;
use Exporter;
@ISA = qw(Exporter);
my @events = (
    "get_events",
    "registered",
    "new_ldap_config",
    "new_key",
    "generate_hw_digest",
    "detect_hardware",
    "confirm_new_key",
    "ping",
    "import_events",
    );
@EXPORT = @events;

use strict;
use warnings;
use Data::Dumper;
use Fcntl;
use utf8;
use open ':utf8';
use GOSA::GosaSupportDaemon;
use File::Basename;


my ($ldap_enabled, $ldap_config, $pam_config, $nss_config, $fai_logpath);


my %cfg_defaults = (
    "client" => {
        "ldap" => [\$ldap_enabled, 1],
        "ldap-config" => [\$ldap_config, "/etc/ldap/ldap.conf"],
        "pam-config" => [\$pam_config, "/etc/pam_ldap.conf"],
        "nss-config" => [\$nss_config, "/etc/libnss_ldap.conf"],
        "fai-logpath" => [\$fai_logpath, "/var/log/fai/fai.log"],
    },
);

BEGIN {}

END {}

### Start ######################################################################

&main::read_configfile($main::cfg_file, %cfg_defaults);


my $server_address = $main::server_address;
my $server_key = $main::server_key;
my $client_mac_address = $main::client_mac_address;

sub write_to_file {
    my ($string, $file) = @_;
    my $error = 0;

    if( not defined $file || not -f $file ) {
        &main::daemon_log("ERROR: $0: check '-f file' failed: $file", 1);
        $error++;
    }
    if( not defined $string || 0 == length($string)) {
        &main::daemon_log("ERROR: $0: empty string to write to file '$file'", 1);
        $error++;
    }
    
    if( $error == 0 ) {

        chomp($string);
            
        if( not -f $file ) {
            open (FILE, "$file");
            close(FILE);
        }
        open(FILE, ">> $file") or &main::daemon_log("ERROR in corefunctions.pm: can not open '$file' to write '$string'", 1);;
        print FILE $string."\n";
        close(FILE);
    }

    return;    
}


sub get_events {
    return \@events;
}

sub daemon_log {
    my ($msg, $level) = @_ ;
    &main::daemon_log($msg, $level);
    return;
}

sub registered {
    my ($msg, $msg_hash) = @_ ;

    my $header = @{$msg_hash->{'header'}}[0];
    if( $header eq "registered" ) {
        my $source = @{$msg_hash->{'source'}}[0];
        &main::daemon_log("registration at $source",1);
        $main::server_address = $source;
    }

    # set globaly variable client_address
    my $target =  @{$msg_hash->{'target'}}[0];
    $main::client_address = $target;

    # set registration_flag to true 
    my $out_hash = &create_xml_hash("registered", $main::client_address, $main::server_address);
     # Write the MAC address to file
    if(stat($main::opts_file)) { 
            unlink($main::opts_file);
    }

    my $opts_file_FH;
    my $hostname= $main::client_dnsname;
    $hostname =~ s/\..*$//;
    open($opts_file_FH, ">$main::opts_file");
    print $opts_file_FH "MAC=\"$main::client_mac_address\"\n";
    print $opts_file_FH "IPADDRESS=\"$main::client_ip\"\n";
    print $opts_file_FH "HOSTNAME=\"$hostname\"\n";
    print $opts_file_FH "FQDN=\"$main::client_dnsname\"\n";
    if(defined(@{$msg_hash->{'ldap_available'}}) &&
	           @{$msg_hash->{'ldap_available'}}[0] eq "true") {
    	print $opts_file_FH "LDAP_AVAILABLE=\"true\"\n";
	}
    close($opts_file_FH);
     
    my $out_msg = &create_xml_string($out_hash);
    return $out_msg;
}

sub server_leaving {
    my ($msg_hash) = @_ ;
    my $source = @{$msg_hash->{'source'}}[0]; 
    my $header = @{$msg_hash->{'header'}}[0];
    
    daemon_log("gosa-si-server $source is going down, cause registration procedure", 1);
    $main::server_address = "none";
    $main::server_key = "none";

    # reinitialization of default values in config file
    &main::read_configfile;
    
    # registrated at new daemon
    &main::register_at_server();
       
    return;   
}


sub new_ldap_config {
    my ($msg, $msg_hash) = @_ ;

    if( $ldap_enabled != 1 ) {
	    return;
    }

    my $element;
    my @ldap_uris;
    my $ldap_base;
    my @ldap_options;
    my @pam_options;
    my @nss_options;
    my $goto_admin;
    my $goto_secret;
    my $admin_base= "";
    my $department= "";
    my $release= "";
    my $unit_tag;

    # Transform input into array
    while ( my ($key, $value) = each(%$msg_hash) ) {
        if ($key =~ /^(source|target|header)$/) {
                next;
        }

        foreach $element (@$value) {
                if ($key =~ /^ldap_uri$/) {
                        push (@ldap_uris, $element);
                        next;
                }
                if ($key =~ /^ldap_base$/) {
                        $ldap_base= $element;
                        next;
                }
                if ($key =~ /^goto_admin$/) {
                        $goto_admin= $element;
                        next;
                }
                if ($key =~ /^goto_secret$/) {
                        $goto_secret= $element;
                        next;
                }
                if ($key =~ /^ldap_cfg$/) {
                        push (@ldap_options, "$element");
                        next;
                }
                if ($key =~ /^pam_cfg$/) {
                        push (@pam_options, "$element");
                        next;
                }
                if ($key =~ /^nss_cfg$/) {
                        push (@nss_options, "$element");
                        next;
                }
                if ($key =~ /^admin_base$/) {
                        $admin_base= $element;
                        next;
                }
                if ($key =~ /^department$/) {
                        $department= $element;
                        next;
                }
                if ($key =~ /^unit_tag$/) {
                        $unit_tag= $element;
                        next;
                }
                if ($key =~ /^release$/) {
                        $release= $element;
                        next;
                }
        }
    }

    # Unit tagging enabled?
    if (defined $unit_tag){
            push (@pam_options, "pam_filter gosaUnitTag=$unit_tag");
            push (@nss_options, "nss_base_passwd  $admin_base?sub?gosaUnitTag=$unit_tag");
            push (@nss_options, "nss_base_group   $admin_base?sub?gosaUnitTag=$unit_tag");
    }

    # Setup ldap.conf
    my $file1;
    my $file2;
    open(file1, "> $ldap_config");
    print file1 "# This file was automatically generated by gosa-si-client. Do not change.\n";
    print file1 "URI";
    foreach $element (@ldap_uris) {
        print file1 " $element";
    }
    print file1 "\nBASE $ldap_base\n";
    foreach $element (@ldap_options) {
        print file1 "$element\n";
    }
    close (file1);
    daemon_log("wrote $ldap_config", 5);

    # Setup pam_ldap.conf / libnss_ldap.conf
    open(file1, "> $pam_config");
    open(file2, "> $nss_config");
    print file1 "# This file was automatically generated by gosa-si-client. Do not change.\n";
    print file2 "# This file was automatically generated by gosa-si-client. Do not change.\n";
    print file1 "uri";
    print file2 "uri";
    foreach $element (@ldap_uris) {
        print file1 " $element";
        print file2 " $element";
    }
    print file1 "\nbase $ldap_base\n";
    print file2 "\nbase $ldap_base\n";
    foreach $element (@pam_options) {
        print file1 "$element\n";
    }
    foreach $element (@nss_options) {
        print file2 "$element\n";
    }
    close (file2);
    daemon_log("wrote $nss_config", 5);
    close (file1);
    daemon_log("wrote $pam_config", 5);

    # Create goto.secrets if told so - for compatibility reasons
    if (defined $goto_admin){
	    open(file1, "> /etc/goto/secret");
            close(file1);
            chown(0,0, "/etc/goto/secret");
            chmod(0600, "/etc/goto/secret");
	    open(file1, "> /etc/goto/secret");
            print file1 "GOTOADMIN=\"$goto_admin\"\nGOTOSECRET=\"$goto_secret\"\n";
            close(file1);
            daemon_log("wrote /etc/goto/secret", 5);
    }

    # Write shell based config
    my $cfg_name= dirname($ldap_config)."/ldap-shell.conf";

    # Get first LDAP server
    my $ldap_server= $ldap_uris[0];
    $ldap_server=~ s/^ldap:\/\/([^:]+).*$/$1/;

    open(file1, "> $cfg_name");
    print file1 "LDAP_BASE=\"$ldap_base\"\n";
    print file1 "LDAP_SERVER=\"$ldap_server\"\n";
    print file1 "ADMIN_BASE=\"$admin_base\"\n";
    print file1 "DEPARTMENT=\"$department\"\n";
    print file1 "RELEASE=\"$release\"\n";
    print file1 "UNIT_TAG=\"".(defined $unit_tag ? "$unit_tag" : "")."\"\n";
    print file1 "UNIT_TAG_FILTER=\"".(defined $unit_tag ? "(gosaUnitTag=$unit_tag)" : "")."\"\n";
    close(file1);
    daemon_log("wrote $cfg_name", 5);

    return;
}


sub new_key {
    # my ($msg_hash) = @_ ;
    my $new_server_key = &main::create_passwd();

    my $out_hash = &create_xml_hash("new_key", $main::client_address, $main::server_address, $new_server_key);    
    my $out_msg = &create_xml_string($out_hash);
    return $out_msg; 
}


sub confirm_new_key {
    my ($msg, $msg_hash) = @_ ;
    my $header = @{$msg_hash->{'header'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];

    &main::daemon_log("confirm new key from $source", 5);
    return;

}


sub detect_hardware {


    &write_to_file('goto-hardware-detection-start', $fai_logpath);

	my $hwinfo= `which hwinfo`;
	chomp $hwinfo;

	if (!(defined($hwinfo) && length($hwinfo) > 0)) {
		&main::daemon_log("ERROR: hwinfo was not found in \$PATH! Hardware detection will not work!", 1);
		return;
	}

	my $result= {
		gotoHardwareChecksum => &main::generate_hw_digest(),
		macAddress      => $client_mac_address,
		gotoXMonitor    => "",
		gotoXDriver     => "",
		gotoXMouseType  => "",
		gotoXMouseport  => "",
		gotoXkbModel    => "",
		gotoXHsync      => "",
		gotoXVsync      => "",
		gotoXResolution => "",
		ghUsbSupport    => "",
		gotoSndModule   => "",
		ghGfxAdapter    => "",
		ghNetNic        => "",
		ghSoundAdapter  => "",
		ghMemSize       => "",
		ghCpuType       => "",
		gotoModules     => [],
		ghIdeDev        => [],
		ghScsiDev       => [],
	};

	&main::daemon_log("Starting hardware detection", 4);
	my $gfxcard= `$hwinfo --gfxcard`;
	my $primary_adapter= $1 if $gfxcard =~ /^Primary display adapter:\s#(\d+)\n/m;
	if(defined($primary_adapter)) {
		($result->{ghGfxAdapter}, $result->{gotoXDriver}) = ($1,$2) if 
			$gfxcard =~ /$primary_adapter:.*?Model:\s\"([^\"]*)\".*?Server Module:\s(\w*).*?\n\n/s;
	}
	my $monitor= `$hwinfo --monitor`;
	my $primary_monitor= $1 if $monitor =~ /^(\d*):.*/m;
	if(defined($primary_monitor)) {
		($result->{gotoXMonitor}, $result->{gotoXResolution}, $result->{gotoXVsync}, $result->{gotoXHsync})= ($1,$2,$3,$4) if 
		$monitor =~ /$primary_monitor:\s.*?Model:\s\"(.*?)\".*?Max\.\sResolution:\s([0-9x]*).*?Vert\.\sSync\sRange:\s([\d\-]*)\sHz.*?Hor\.\sSync\sRange:\s([\d\-]*)\skHz.*/s;
	}

	if(length($result->{gotoXHsync}) == 0) {
		# set default values
		$result->{gotoXHsync} = "30+50";
		$result->{gotoXVsync} = "30+90";
	}

	my $mouse= `$hwinfo --mouse`;
	my $primary_mouse= $1 if $mouse =~ /^(\d*):.*/m;
	if(defined($primary_mouse)) {
		($result->{gotoXMouseport}, $result->{gotoXMouseType}) = ($1,$2) if
		$mouse =~ /$primary_mouse:\s.*?Device\sFile:\s(.*?)\s.*?XFree86\sProtocol:\s(.*?)\n.*?/s;
	}

	my $sound= `$hwinfo --sound`;
	my $primary_sound= $1 if $sound =~ /^(\d*):.*/m;
	if(defined($primary_sound)) {
		($result->{ghSoundAdapter}, $result->{gotoSndModule})= ($1,$2) if 
		$sound =~ /$primary_sound:\s.*?Model:\s\"(.*?)\".*?Driver\sModules:\s\"(.*?)\".*/s;
	}

	my $netcard= `hwinfo --netcard`;
	my $primary_netcard= $1 if $netcard =~ /^(\d*):.*/m;
	if(defined($primary_netcard)) {
		$result->{ghNetNic}= $1 if $netcard =~ /$primary_netcard:\s.*?Model:\s\"(.*?)\".*/s;
	}

	my $keyboard= `hwinfo --keyboard`;
	my $primary_keyboard= $1 if $keyboard =~ /^(\d*):.*/m;
	if(defined($primary_keyboard)) {
		$result->{gotoXkbModel}= $1 if $keyboard =~ /$primary_keyboard:\s.*?XkbModel:\s(.*?)\n.*/s;
	}

	$result->{ghCpuType}= sprintf "%s / %s - %s", 
	`cat /proc/cpuinfo` =~ /.*?vendor_id\s+:\s(.*?)\n.*?model\sname\s+:\s(.*?)\n.*?cpu\sMHz\s+:\s(.*?)\n.*/s;
	$result->{ghMemSize}= $1 if `cat /proc/meminfo` =~ /^MemTotal:\s+(.*?)\skB.*/s;

	my @gotoModules=();
	for my $line(`lsmod`) {
		if (($line =~ /^Module.*$/) or ($line =~ /^snd.*$/)) {
			next;
		} else {
			push @gotoModules, $1 if $line =~ /^(\w*).*$/
		}
	}
	my %seen = ();
	
	# Remove duplicates and save
	push @{$result->{gotoModules}}, grep { ! $seen{$_} ++ } @gotoModules;

	$result->{ghUsbSupport} = (-d "/proc/bus/usb")?"true":"false";
	
	foreach my $device(`hwinfo --ide` =~ /^.*?Model:\s\"(.*?)\".*$/mg) {
		push @{$result->{ghIdeDev}}, $device;
	}

	foreach my $device(`hwinfo --scsi` =~ /^.*?Model:\s\"(.*?)\".*$/mg) {
		push @{$result->{ghScsiDev}}, $device;
	}

	&main::daemon_log("Hardware detection done!", 4);

    &write_to_file('goto-hardware-detection-stop', $fai_logpath);
   
    return &main::send_msg_hash_to_target(
		&main::create_xml_hash("detected_hardware", $main::client_address, $main::server_address, $result),
		$main::server_address, 
		$main::server_key,
	);
}


sub ping {
    my ($msg, $msg_hash) = @_ ;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $session_id = @{$msg_hash->{'session_id'}}[0];

   
    # switch target and source and send msg back
    my $out_hash = &main::create_xml_hash("got_ping", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);
    my $out_msg = &main::create_xml_string($out_hash);
    return $out_msg;

}

1;

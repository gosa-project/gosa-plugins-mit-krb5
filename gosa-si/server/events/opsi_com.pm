## @file
# @details A GOsa-SI-server event module containing all functions for message handling.
# @brief Implementation of an event module for GOsa-SI-server. 


package opsi_com;
use Exporter;
@ISA = qw(Exporter);
my @events = (
    "get_events",
    "opsi_install_client",
    #"opsi_get_netboot_products",  
    #"opsi_get_local_products",
    #"opsi_get_client_hardware",
    #"opsi_get_client_software",
    #"opsi_get_product_properties",
    #"opsi_set_product_properties",
    #"opsi_list_clients",
    #"opsi_del_client",
    #"opsi_install_client",

   );
@EXPORT = @events;

use strict;
use warnings;
use GOSA::GosaSupportDaemon;
use Data::Dumper;


BEGIN {}

END {}

## @method get_events()
# A brief function returning a list of functions which are exported by importing the module.
# @return List of all provided functions
sub get_events {
    return \@events;
}

    
## @method opsi_install_client
# A new windows installing job is created at job_queue_db.
# @param msg - STRING - xml message with tags macaddress and hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_install_client {
    my ($msg, $msg_hash, $session_id) = @_ ;
    my $error = 0;
    my $out_msg;
    my $out_hash;

    # Prepare incoming message
    $msg =~ s/<header>gosa_/<header>/;
    $msg_hash->{'header'}[0] =~ s/gosa_//;


    # Assign variables
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];


    # If no timestamp is specified in incoming message, use 19700101000000
    my $timestamp = "19700101000000";
    if( exists $msg_hash->{'timestamp'} ) {
        $timestamp = @{$msg_hash->{'timestamp'}}[0];
    }
     

    # If no macaddress is specified, raise error 
    my $macaddress;
    if ((exists $msg_hash->{'macaddress'}) &&
            ($msg_hash->{'macaddress'}[0] =~ /^([0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})$/i)) { 
        $macaddress = $1;
    } else {
        $error ++;
        $out_msg = "<xml>".
            "<header>answer</header>".
            "<source>$main::server_address</source>".
            "<target>GOSA</target>".
            "<answer1>1</answer1>".
            "<error_string>no mac address specified in macaddres-tag</error_string>".
            "</xml>";
    }
    

    # Set hostID to plain_name
    my $plain_name;
    if (not $error) {
        if (exists $msg_hash->{'hostId'}) {
            $plain_name = $msg_hash->{'hostId'}[0];
        } else {
            $error++;
            $out_msg = "<xml>".
            "<header>answer</header>".
            "<source>$main::server_address</source>".
            "<target>GOSA</target>".
            "<answer1>1</answer1>".
            "<error_string>no hostId specified in hostId-tag</error_string>".
            "</xml>";
        }
    }


    # Add installation job to job queue
    if (not $error) {
        my $insert_dic = {table=>$main::job_queue_tn, 
            primkey=>['macaddress', 'headertag'],
            timestamp=>&get_time(),
            status=>'processing', 
            result=>'none',
            progress=>'none',
            headertag=>$header, 
            targettag=>$target,
            xmlmessage=>$msg,
            macaddress=>$macaddress,
            plainname=>$plain_name,
            siserver=>"localhost",
            modified=>"1",
        };
        my $res = $main::job_db->add_dbentry($insert_dic);
        if (not $res == 0) {
            &main::daemon_log("$session_id ERROR: Cannot add opsi-job to job_queue: $msg", 1);
        } else {
            &main::daemon_log("$session_id INFO: '$header'-job successfully added to job queue", 5);
        }
        $out_msg = $msg;   # forward GOsa message to client 
    }
    
    return ($out_msg);
}


## @method opsi_get_netboot_products
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_get_netboot_products {
  my ($msg, $msg_hash, $session_id) = @_;
  my $header = @{$msg_hash->{'header'}}[0];
  my $source = @{$msg_hash->{'source'}}[0];
  my $target = @{$msg_hash->{'target'}}[0];
  my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
  my $hostId;

  # build return message with twisted target and source
  my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
  #&add_content2xml_hash($out_hash, "session_id", $session_id);   ### possibly not needed, to be checked
  if (defined $forward_to_gosa) {
    &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
  }

  # Get hostID if defined
  if (defined @{$msg_hash->{'hostId'}}[0]){
    $hostId = @{$msg_hash->{'hostId'}}[0];
    &add_content2xml_hash($out_hash, "hostId", $hostId);
  }

  &add_content2xml_hash($out_hash, "xxx", "");
  my $xml_msg= &create_xml_string($out_hash);

  # For hosts, only return the products that are or get installed
  my $callobj;
  $callobj = {
    method  => 'getNetBootProductIds_list',
    params  => [ ],
    id  => 1,
  };

  my $res = $main::opsi_client->call($main::opsi_url, $callobj);
  my %r = ();
  for (@{$res->result}) { $r{$_} = 1 }

  if (check_res($res)){

    if (defined $hostId){
      $callobj = {
        method  => 'getProductStates_hash',
        params  => [ $hostId ],
        id  => 1,
      };

      my $hres = $main::opsi_client->call($main::opsi_url, $callobj);
      if (check_res($hres)){
        my $htmp= $hres->result->{$hostId};

        # check state != not_installed or action == setup -> load and add
        foreach my $product (@{$htmp}){

          if (!defined ($r{$product->{'productId'}})){
            next;
          }

          # Now we've a couple of hashes...
          if ($product->{'installationStatus'} ne "not_installed" or
              $product->{'actionRequest'} eq "setup"){
            my $state= "<state>".$product->{'installationStatus'}."</state><action>".$product->{'actionRequest'}."</action>";

            $callobj = {
              method  => 'getProduct_hash',
              params  => [ $product->{'productId'} ],
              id  => 1,
            };

            my $sres = $main::opsi_client->call($main::opsi_url, $callobj);
            if (check_res($sres)){
              my $tres= $sres->result;

              my $name= xml_quote($tres->{'name'});
              my $r= $product->{'productId'};
              my $description= xml_quote($tres->{'description'});
              $name=~ s/\//\\\//;
              $description=~ s/\//\\\//;
              $xml_msg=~ s/<xxx><\/xxx>/<item><ProductId>$r<\/ProductId><name><\/name><description>$description<\/description><\/item>$state<xxx><\/xxx>/;
            }

          }
        }

      }

    } else {
      foreach my $r (@{$res->result}) {
        $callobj = {
          method  => 'getProduct_hash',
          params  => [ $r ],
          id  => 1,
        };

        my $sres = $main::opsi_client->call($main::opsi_url, $callobj);
        if (check_res($sres)){
          my $tres= $sres->result;

          my $name= xml_quote($tres->{'name'});
          my $description= xml_quote($tres->{'description'});
          $name=~ s/\//\\\//;
          $description=~ s/\//\\\//;
          $xml_msg=~ s/<xxx><\/xxx>/<item><ProductId>$r<\/ProductId><name><\/name><description>$description<\/description><\/item><xxx><\/xxx>/;
        }

      }

    }
  }

  $xml_msg=~ s/<xxx><\/xxx>//;

  return ($xml_msg);
}


## @method opsi_get_product_properties
# ???
# @param msg - STRING - xml message with tags ProductId and hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_get_product_properties {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $productId = @{$msg_hash->{'ProductId'}}[0];
    my $hostId;

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    # Get hostID if defined
    if (defined @{$msg_hash->{'hostId'}}[0]){
      $hostId = @{$msg_hash->{'hostId'}}[0];
      &add_content2xml_hash($out_hash, "hostId", $hostId);
    }

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }
    &add_content2xml_hash($out_hash, "ProducId", "$productId");

    # Load actions
    my $callobj = {
      method  => 'getPossibleProductActions_list',
      params  => [ $productId ],
      id  => 1,
    };
    my $res = $main::opsi_client->call($main::opsi_url, $callobj);
    if (check_res($res)){
      foreach my $action (@{$res->result}){
        &add_content2xml_hash($out_hash, "action", $action);
      }
    }

    # Add place holder
    &add_content2xml_hash($out_hash, "xxx", "");

    # Move to XML string
    my $xml_msg= &create_xml_string($out_hash);

    # JSON Query
    $callobj = {
      method  => 'getProductProperties_hash',
      params  => [ $productId ],
      id  => 1,
    };

    $res = $main::opsi_client->call($main::opsi_url, $callobj);

    if (check_res($res)){
        my $r= $res->result;
        foreach my $key (keys %{$r}) {
          my $item= "<item>";
          my $value= $r->{$key};
          if (UNIVERSAL::isa( $value, "ARRAY" )){
            foreach my $subval (@{$value}){
              $item.= "<$key>".xml_quote($subval)."</$key>";
            }
          } else {
            $item.= "<$key>".xml_quote($value)."</$key>";
          }
          $item.= "</item>";
          $xml_msg=~ s/<xxx><\/xxx>/$item<xxx><\/xxx>/;
        }
    }


  $xml_msg=~ s/<xxx><\/xxx>//;

  return ($xml_msg);
}


## @method opsi_set_product_properties
# ???
# @param msg - STRING - xml message with tags ProductId, hostId, action and state
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_set_product_properties {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $productId = @{$msg_hash->{'ProductId'}}[0];
    my $hostId;

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);
    &add_content2xml_hash($out_hash, "ProductId", $productId);

    # Get hostID if defined
    if (defined @{$msg_hash->{'hostId'}}[0]){
      $hostId = @{$msg_hash->{'hostId'}}[0];
      &add_content2xml_hash($out_hash, "hostId", $hostId);
    }

    # Set product states if requested
    if (defined @{$msg_hash->{'action'}}[0]){
      &_set_action($productId, @{$msg_hash->{'action'}}[0], $hostId);
    }
    if (defined @{$msg_hash->{'state'}}[0]){
      &_set_state($productId, @{$msg_hash->{'state'}}[0], $hostId);
    }

    if (defined $forward_to_gosa) {
        &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }

    # Find properties
    foreach my $item (@{$msg_hash->{'item'}}){
      # JSON Query
      my $callobj;

      if (defined $hostId){
        $callobj = {
          method  => 'setProductProperty',
          params  => [ $productId, $item->{'name'}[0], $item->{'value'}[0], $hostId ],
          id  => 1,
        };
      } else {
        $callobj = {
          method  => 'setProductProperty',
          params  => [ $productId, $item->{'name'}[0], $item->{'value'}[0] ],
          id  => 1,
        };
      }

      my $res = $main::opsi_client->call($main::opsi_url, $callobj);

      if (!check_res($res)){
        &main::daemon_log("ERROR: no communication failed while setting '".$item->{'name'}[0]."': ".$res->error_message, 1);
        &add_content2xml_hash($out_hash, "error", $res->error_message);
      }

    }

    # return message
    return ( &create_xml_string($out_hash) );
}


## @method opsi_get_client_hardware
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_get_client_hardware {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $hostId = @{$msg_hash->{'hostId'}}[0];

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }
    &add_content2xml_hash($out_hash, "hostId", "$hostId");
    &add_content2xml_hash($out_hash, "xxx", "");
    my $xml_msg= &create_xml_string($out_hash);

    # JSON Query
    my $callobj = {
      method  => 'getHardwareInformation_hash',
      params  => [ $hostId ],
      id  => 1,
    };

    my $res = $main::opsi_client->call($main::opsi_url, $callobj);
    if (check_res($res)){
      my $result= $res->result;
      foreach my $r (keys %{$result}){
        my $item= "<item><id>".xml_quote($r)."</id>";
        my $value= $result->{$r};
        foreach my $sres (@{$value}){

          foreach my $dres (keys %{$sres}){
            if (defined $sres->{$dres}){
              $item.= "<$dres>".xml_quote($sres->{$dres})."</$dres>";
            }
          }

        }
          $item.= "</item>";
          $xml_msg=~ s%<xxx></xxx>%$item<xxx></xxx>%;

      }
    }

    $xml_msg=~ s/<xxx><\/xxx>//;

    return ( $xml_msg );
}


## @method opsi_list_clients
# ???
# @param msg - STRING - xml message 
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_list_clients {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }

    &add_content2xml_hash($out_hash, "xxx", "");
    my $xml_msg= &create_xml_string($out_hash);

    # JSON Query
    my $callobj = {
      method  => 'getClients_listOfHashes',
      params  => [ ],
      id  => 1,
    };

    my $res = $main::opsi_client->call($main::opsi_url, $callobj);
    if (check_res($res)){

      foreach my $host (@{$res->result}){
        my $item= "<item><name>".$host->{'hostId'}."</name>";
        if (defined($host->{'description'})){
          $item.= "<description>".xml_quote($host->{'description'})."</description>";
        }
        $item.= "</item>";
        $xml_msg=~ s%<xxx></xxx>%$item<xxx></xxx>%;
      }

    }

    $xml_msg=~ s/<xxx><\/xxx>//;
    return ( $xml_msg );
}


## @method opsi_get_client_software
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_get_client_software {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $hostId = @{$msg_hash->{'hostId'}}[0];

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }
    &add_content2xml_hash($out_hash, "hostId", "$hostId");
    &add_content2xml_hash($out_hash, "xxx", "");
    my $xml_msg= &create_xml_string($out_hash);

    # JSON Query
    my $callobj = {
      method  => 'getSoftwareInformation_hash',
      params  => [ $hostId ],
      id  => 1,
    };

    my $res = $main::opsi_client->call($main::opsi_url, $callobj);
    if (check_res($res)){
      my $result= $res->result;
    }

    $xml_msg=~ s/<xxx><\/xxx>//;

    return ( $xml_msg );
}


## @method opsi_get_local_products
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_get_local_products {
  my ($msg, $msg_hash, $session_id) = @_;
  my $header = @{$msg_hash->{'header'}}[0];
  my $source = @{$msg_hash->{'source'}}[0];
  my $target = @{$msg_hash->{'target'}}[0];
  my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
  my $hostId;

  # build return message with twisted target and source
  my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
  &add_content2xml_hash($out_hash, "session_id", $session_id);

  # Get hostID if defined
  if (defined @{$msg_hash->{'hostId'}}[0]){
    $hostId = @{$msg_hash->{'hostId'}}[0];
    &add_content2xml_hash($out_hash, "hostId", $hostId);
  }

  if (defined $forward_to_gosa) {
    &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
  }
  &add_content2xml_hash($out_hash, "xxx", "");
  my $xml_msg= &create_xml_string($out_hash);

  # For hosts, only return the products that are or get installed
  my $callobj;
  $callobj = {
    method  => 'getLocalBootProductIds_list',
    params  => [ ],
    id  => 1,
  };

  my $res = $main::opsi_client->call($main::opsi_url, $callobj);
  my %r = ();
  for (@{$res->result}) { $r{$_} = 1 }

  if (check_res($res)){

    if (defined $hostId){
      $callobj = {
        method  => 'getProductStates_hash',
        params  => [ $hostId ],
        id  => 1,
      };

      my $hres = $main::opsi_client->call($main::opsi_url, $callobj);
      if (check_res($hres)){
        my $htmp= $hres->result->{$hostId};

        # check state != not_installed or action == setup -> load and add
        foreach my $product (@{$htmp}){

          if (!defined ($r{$product->{'productId'}})){
            next;
          }

          # Now we've a couple of hashes...
          if ($product->{'installationStatus'} ne "not_installed" or
              $product->{'actionRequest'} eq "setup"){
            my $state= "<state>".$product->{'installationStatus'}."</state><action>".$product->{'actionRequest'}."</action>";

            $callobj = {
              method  => 'getProduct_hash',
              params  => [ $product->{'productId'} ],
              id  => 1,
            };

            my $sres = $main::opsi_client->call($main::opsi_url, $callobj);
            if (check_res($sres)){
              my $tres= $sres->result;

              my $name= xml_quote($tres->{'name'});
              my $r= $product->{'productId'};
              my $description= xml_quote($tres->{'description'});
              $name=~ s/\//\\\//;
              $description=~ s/\//\\\//;
              $xml_msg=~ s/<xxx><\/xxx>/<item><ProductId>$r<\/ProductId><name><\/name><description>$description<\/description><\/item>$state<xxx><\/xxx>/;
            }

          }
        }

      }

    } else {
      foreach my $r (@{$res->result}) {
        $callobj = {
          method  => 'getProduct_hash',
          params  => [ $r ],
          id  => 1,
        };

        my $sres = $main::opsi_client->call($main::opsi_url, $callobj);
        if (check_res($sres)){
          my $tres= $sres->result;

          my $name= xml_quote($tres->{'name'});
          my $description= xml_quote($tres->{'description'});
          $name=~ s/\//\\\//;
          $description=~ s/\//\\\//;
          $xml_msg=~ s/<xxx><\/xxx>/<item><ProductId>$r<\/ProductId><name><\/name><description>$description<\/description><\/item><xxx><\/xxx>/;
        }

      }

    }
  }

  $xml_msg=~ s/<xxx><\/xxx>//;

  return ( $xml_msg );
}


### @method _opsi_get_client_status
## 
## @param msg - STRING - xml message with tags 
## @param msg_hash - HASHREF - message information parsed into a hash
## @param session_id - INTEGER - POE session id of the processing of this message
#sub _opsi_get_client_status {
#  my $hostId = shift;
#  my $result= {};
#
#  # For hosts, only return the products that are or get installed
#  my $callobj;
#  $callobj = {
#    method  => 'getProductStates_hash',
#    params  => [ $hostId ],
#    id  => 1,
#  };
#
#  my $hres = $main::opsi_client->call($main::opsi_url, $callobj);
#  if (check_res($hres)){
#    my $htmp= $hres->result->{$hostId};
#
#    # check state != not_installed or action == setup -> load and add
#    my $products= 0;
#    my $installed= 0;
#    my $error= 0;
#    foreach my $product (@{$htmp}){
#
#      if ($product->{'installationStatus'} ne "not_installed" or
#          $product->{'actionRequest'} eq "setup"){
#
#        # Increase number of products for this host
#        $products++;
#
#        if ($product->{'installationStatus'} eq "failed"){
#          $result->{$product->{'productId'}}= "error";
#          $error++;
#        }
#        if ($product->{'installationStatus'} eq "installed"){
#          $result->{$product->{'productId'}}= "installed";
#          $installed++;
#        }
#        if ($product->{'installationStatus'} eq "installing"){
#          $result->{$product->{'productId'}}= "installing";
#        }
#      }
#    }
#
#    # Estimate "rough" progress
#    $result->{'progress'}= int($installed * 100 / $products);
#  }
#
#  return $result;
#}


## @method opsi_del_client
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_del_client {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $hostId = @{$msg_hash->{'hostId'}}[0];

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }
    &add_content2xml_hash($out_hash, "hostId", "$hostId");

    # JSON Query
    my $callobj = {
      method  => 'deleteClient',
      params  => [ $hostId ],
      id  => 1,
    };

    my $res = $main::opsi_client->call($main::opsi_url, $callobj);

    my $xml_msg= &create_xml_string($out_hash);
    return ( $xml_msg );
}


## @method opsi_install_client
# ???
# @param msg - STRING - xml message with tag hostId
# @param msg_hash - HASHREF - message information parsed into a hash
# @param session_id - INTEGER - POE session id of the processing of this message
sub opsi_install_client {
    my ($msg, $msg_hash, $session_id) = @_;
    my $header = @{$msg_hash->{'header'}}[0];
    my $source = @{$msg_hash->{'source'}}[0];
    my $target = @{$msg_hash->{'target'}}[0];
    my $forward_to_gosa = @{$msg_hash->{'forward_to_gosa'}}[0];
    my $hostId = @{$msg_hash->{'hostId'}}[0];

    # build return message with twisted target and source
    my $out_hash = &main::create_xml_hash("answer_$header", $target, $source);
    &add_content2xml_hash($out_hash, "session_id", $session_id);

    if (defined $forward_to_gosa) {
      &add_content2xml_hash($out_hash, "forward_to_gosa", $forward_to_gosa);
    }
    &add_content2xml_hash($out_hash, "hostId", "$hostId");

    # Load all products for this host with status != "not_installed" or actionRequest != "none"
    if (defined $hostId){
      my $callobj = {
        method  => 'getProductStates_hash',
        params  => [ $hostId ],
        id  => 1,
      };

      my $hres = $main::opsi_client->call($main::opsi_url, $callobj);
      if (check_res($hres)){
        my $htmp= $hres->result->{$hostId};

        # check state != not_installed or action == setup -> load and add
        foreach my $product (@{$htmp}){

          # Now we've a couple of hashes...
          if ($product->{'installationStatus'} ne "not_installed" or
              $product->{'actionRequest'} ne "none"){

            # Do an action request for all these -> "setup".
            $callobj = {
              method  => 'setProductActionRequest',
              params  => [ $product->{'productId'}, $hostId, "setup" ],
              id  => 1,
            };
            my $res = $main::opsi_client->call($main::opsi_url, $callobj);
            if (!check_res($res)){
              &main::daemon_log("ERROR: cannot set product action request for $hostId!", 1);
            } else {
              &main::daemon_log("INFO: requesting 'setup' for '".$product->{'productId'}."' on $hostId", 1);
            }

          }
        }
      }
    }



#    # JSON Query
#    my $callobj = {
#      method  => 'deleteClient',
#      params  => [ $hostId ],
#      id  => 1,
#    };
#
#    my $res = $main::opsi_client->call($main::opsi_url, $callobj);

    my $xml_msg= &create_xml_string($out_hash);
    return ($xml_msg);
}


## @method _set_action
# ???
# @param product - STRING - ???
# @param action - STRING - ???
# @param hostId - STRING - ???
sub _set_action {
  my $product= shift;
  my $action = shift;
  my $hostId = shift;
  my $callobj;

  $callobj = {
    method  => 'setProductActionRequest',
    params  => [ $product, $hostId, $action],
    id  => 1,
  };

  $main::opsi_client->call($main::opsi_url, $callobj);
}

## @method _set_state
# ???
# @param product - STRING - ???
# @param action - STRING - ???
# @param hostId - STRING - ???
sub _set_state {
  my $product = shift;
  my $hostId = shift;
  my $action = shift;
  my $callobj;

  $callobj = {
    method  => 'setProductState',
    params  => [ $product, $hostId, $action ],
    id  => 1,
  };

  $main::opsi_client->call($main::opsi_url, $callobj);
}

1;

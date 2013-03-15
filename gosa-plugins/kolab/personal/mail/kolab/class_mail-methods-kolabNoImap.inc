<?php

class mailMethodKolabNoImap extends mailMethodKolab
{
    protected $enableSieveManager   = FALSE;

    /*! \brief  Checks whether this account is removeable or not.
      There may be some dependencies left, eg. kolab.
     */
    public function accountRemoveable(&$reason = ""){
      return(TRUE);
    }
 
    public function fixAttributesOnRemove()
    {
      mailMethod::fixAttributesOnRemove();
      foreach($this->attributes as $source => $dest){
        $this->attrs[$dest]   = array();
        $this->attrs[$source] = array();
        $this->parent->attrs[$dest]   = array();
        $this->parent->attrs[$source] = array();
      }
      if($this->type == "user"){
        $ocs = $this->userObjectClasses;
      }else{
        $ocs = $this->shareObjectClasses;
      }

      if($this->type == "group"){ 
        $this->parent->attrs['gosaSharedFolderTarget'] =array();
      }

      $this->parent->attrs['kolabDeleteflag'] = array();
      $this->parent->attrs['kolabFolderType'] = array();
    } 

    public function allow_remove(&$reason)
    {
      return(TRUE);
    }

    public function connect()
    {
        return(mailMethod::connect());
    }

    public function account_exists()
    {
        return(mailMethod::account_exists());
    }

    public function disconnect()
    {
        return(mailMethod::disconnect());
    }

    public function is_connected()
    {
        return(mailMethod::is_connected());
    }

    public function getQuotaUsage()
    {
        return(mailMethod::getQuotaUsage());
    }

    public function getQuota($quotaValue)
    {
        return(mailMethod::getQuota($quotaValue));
    }

    public function getMailboxList()
    {
        return(mailMethod::getMailboxList());
    }

    public function getFolderACLs($folder_acls)
    {
        return(mailMethod::getFolderACLs($folder_acls));
    }

    public function saveSieveSettings()
    {
        return(mailMethod::saveSieveSettings());
    }
}
// vim:tabstop=2:expandtab:shiftwidth=2:filetype=php:syntax:ruler:
?>

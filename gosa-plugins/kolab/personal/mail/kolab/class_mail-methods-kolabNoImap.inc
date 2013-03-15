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

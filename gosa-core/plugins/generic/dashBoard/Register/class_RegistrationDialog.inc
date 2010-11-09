<?php



/* Missing functions, validate registration
 *
 */

class RegistrationDialog extends plugin
{
    protected $selectedRegistrationType = "registered";
    protected $isRegistered = FALSE; 
    protected $step = 0;

    protected $values = array();
    public $attrs = array('username','password');

    protected $finished = FALSE;

    function finished()
    {
        return($this->finished);
    }

    function __construct(&$config)
    {
        $this->config = $config;    

        // Use empty values initially.
        foreach($this->attrs as $attr) $this->values[$attr] = "";
    }


    function execute()
    {
        $smarty = get_smarty();
        $smarty->assign("error", "");

        // Registration page one filled in, next step requested.
        if(isset($_POST['registerPage1'])){
            $msgs = $this->check();
            if(count($msgs)){
                msg_dialog::displayChecks($msgs); 
            }else{

                if($this->selectedRegistrationType == "registered"){

                    // Try to registrate the instance with the given username and password.
                    $rpcHandle = $this->config->registration->getConnection($this->values['username'],$this->values['password']);
                    $rpcHandle->registerInstance($this->config->getInstanceUuid());
                    if(!$rpcHandle->success()){
                        $code =  $rpcHandle->getHTTPstatusCode();
                        if($code == 0){
                            $smarty->assign("error", _("Communciation with the backend failed! Please check your internet connection!"));
                        }elseif($code == 401){
                            $smarty->assign("error", _("Authentication failed, please check combination of username and password!"));
                        }elseif($code == 403){
                            $smarty->assign("error", _("Internal server error, please try again later. If the problem persists contact the GOsa-Team!"));
                        }
                    }else{
                        $this->step = 2;
                    }
                } 
            }
        }

        $smarty->assign("default", $this->selectedRegistrationType);
        $smarty->assign("step", $this->step);
        foreach($this->attrs as $attr) $smarty->assign($attr, set_post($this->values[$attr]));
        return($smarty->fetch(get_template_path("Register/register.tpl", TRUE))); 
    } 


    function save_object()
    {
        foreach($this->attrs as $attr){
            if(isset($_POST[$attr])) $this->values[$attr] = get_post($attr);
        }

        if(isset($_POST['registrationType']))  $this->selectedRegistrationType = get_post('registrationType');

        // Registration type selected and next page choosen.
        if(isset($_POST['startRegistration'])){
            if($this->selectedRegistrationType == "none"){
                $this->step = 100;
            }else{
                $this->step = 1;
            }
        }
        if(isset($_POST['registerComplete'])) $this->finished = TRUE;
        if(isset($_POST['stepBack'])) $this->step -= 1;
    }
}
?>
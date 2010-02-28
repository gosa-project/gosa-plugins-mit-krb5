<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
	"http://www.w3.org/TR/html4/transitional.dtd">
<html>

<head>
  <title>{if isset($title)}{$title}{else}GOsa{/if}</title>

  <meta name="generator" content="my hands">
  <meta name="description" content="GOsa - Login">
  <meta name="author" lang="de" content="Cajus Pollmeier">

  <meta http-equiv="Expires" content="Mon, 26 Jul 1997 05:00:00 GMT">
  <meta http-equiv="Last-Modified" content="{$date} GMT">
  <meta http-equiv="Cache-Control" content="no-cache">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="Cache-Control" content="post-check=0, pre-check=0">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

  <style type="text/css">@import url('themes/modern/style.css');</style>
  <link rel="stylesheet" type="text/css" href="themes/modern/printer.css" media="print">

  <!--[if IE]>
  <style type="text/css">
    div.listContainer { height: 121px; overflow-x:hidden; overflow-y:auto; }
  </style>
  <![endif]-->

  <!-- Include correct theme icon sets -->
  <style type="text/css">
    div.img{
      background:transparent url(themes/modern/img.png) no-repeat;
      position:relative
    }
    
    div.img div {
      background:transparent url(themes/modern/img.png) no-repeat;
      bottom:0;
      right:0;
      position:absolute;
    }
  </style>

  <link rel="shortcut icon" href="favicon.ico">

{if $iePngWorkaround}
  <script language="javascript" src="include/png.js" type="text/javascript"></script>
{/if}
  <script language="javascript" src="include/prototype.js" type="text/javascript"></script>
  <script language="javascript" src="include/gosa.js" type="text/javascript"></script>
{if $usePrototype == 'true'}
  <script language="javascript" src="include/scriptaculous.js" type="text/javascript"></script>
  <script language="javascript" src="include/effects.js" type="text/javascript"></script>
  <script language="javascript" src="include/dragdrop.js" type="text/javascript"></script>
  <script language="javascript" src="include/controls.js" type="text/javascript"></script>
  <script language="javascript" src="include/pulldown.js" type="text/javascript"></script>
  <script language="javascript" src="include/datepicker.js" type="text/javascript"></script>
{/if}
</head>


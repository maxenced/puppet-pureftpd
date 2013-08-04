# == Class: pureftpd::config
#
# This module manages the pure-ftpd server configuration file
#
# === Parameters
#
# === Authors
#
# 5Ub-Z3r0
# Joshua Hoblitt <jhoblitt@cpan.org>
#
class pureftpd::config(
  $ipv4only                   = undef,
  $ipv6only                   = undef,
  $chrooteveryone             = undef,
  $brokenclientscompatibility = undef,
  $daemonize                  = undef,
  $verboselog                 = undef,
  $displaydotfiles            = undef,
  $anonymousonly              = undef,
  $noanonymous                = undef,
  $dontresolve                = undef,
  $anonymouscancreatedirs     = undef,
  $natmode                    = undef,
  $calluploadscript           = undef,
  $antiwarez                  = undef,
  $allowuserfxp               = undef,
  $allowanonymousfxp          = undef,
  $prohibitdotfileswrite      = undef,
  $prohibitdotfilesread       = undef,
  $allowdotfiles              = undef,
  $autorename                 = undef,
  $anonymouscantupload        = undef,
  $logpid                     = undef,
  $nochmod                    = undef,
  $keepallfiles               = undef,
  $createhomedir              = undef,
  $norename                   = undef,
  $customerproof              = undef,
  $notruncate                 = undef,
  $filesystemcharset          = undef,
  $clientcharset              = undef,
  $syslogfacility             = undef,
  $fortunesfile               = undef,
  $forcepassiveip             = undef,
  $bind                       = undef,
  $anonymousbandwidth         = undef,
  $userbandwidth              = undef,
  $trustedip                  = undef,
  $altlog                     = undef,
  $pidfile                    = undef,
  $maxidletime                = undef,
  $maxdiskusage               = undef,
  $trustedgid                 = undef,
  $maxclientsnumber           = undef,
  $maxclientsperip            = undef,
  $maxload                    = undef,
  $minuid                     = undef,
  $tls                        = undef,
  $limitrecursion             = undef,
  $passiveportrange           = undef,
  $anonymousratio             = undef,
  $userratio                  = undef,
  $umask                      = undef,
) inherits pureftpd::params {

  $conf_options = [
    'IPV4Only',
    'IPV6Only',
    'ChrootEveryone',
    'BrokenClientsCompatibility',
    'Daemonize',
    'VerboseLog',
    'DisplayDotFiles',
    'AnonymousOnly',
    'NoAnonymous',
    'DontResolve',
    'AnonymousCanCreateDirs',
    'NATmode',
    'CallUploadScript',
    'AntiWarez',
    'AllowUserFXP',
    'AllowAnonymousFXP',
    'ProhibitDotFilesWrite',
    'ProhibitDotFilesRead',
    'AllowDotFiles',
    'AutoRename',
    'AnonymousCantUpload',
    'LogPID',
    'NoChmod',
    'KeepAllFiles',
    'CreateHomeDir',
    'NoRename',
    'CustomerProof',
    'NoTruncate',
    'FileSystemCharset',
    'ClientCharset',
    'SyslogFacility',
    'FortunesFile',
    'ForcePassiveIP',
    'Bind',
    'AnonymousBandwidth',
    'UserBandwidth',
    'TrustedIP',
    'AltLog',
    'PIDFile',
    'MaxIdleTime',
    'MaxDiskUsage',
    'TrustedGID',
    'MaxClientsNumber',
    'MaxClientsPerIP',
    'MaxLoad',
    'MinUID',
    'TLS',
    'LimitRecursion',
    'PassivePortRange',
    'AnonymousRatio',
    'UserRatio',
    'Umask',
    'Quota',
    'PerUserLimits',
    'LDAPConfigFile',
    'MySQLConfigFile',
    'PGSQLConfigFile',
    'PureDB',
    'ExtAuth',
  ]

  file { $pureftpd::params::conf_path:
    ensure  => file,
    content => template("${module_name}/${pureftpd::params::conf_erb}"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service[$pureftpd::params::service_name]
  }
}

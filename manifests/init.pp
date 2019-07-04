# == Class: pureftpd
#
# This class installs, configures, and enables the pure-ftpd package
#
# === Parameters
#
# [*use_selinux*]
#   Boolean. Manages whether or not to enable the selinux extensions.
#
#   Optional, defaults to false.
#
# [*config*]
#   A hash of configuration file options to be created in `pure-ftpd.conf`.
#
#   Optional, defaults to `{}`.
#
# [*config_ldap*]
#   A hash of configuration file options to be created in `pureftpd-ldap.conf`.
#
#   Optional, defaults to `{}`.
#
# [*config_mysql*]
#   A hash of configuration file options to be created in `pureftpd-mysql.conf`.
#
#   Optional, defaults to `{}`.
#
# [*config_pgsql*]
#   A hash of configuration file options to be created in `pureftpd-pgsql.conf`.
#
#   Optional, defaults to `{}`.
#
# === Examples
#
#    class { 'pureftpd':
#      use_selinux => true,
#      config      => {
#        ipv4only         => 'Yes',
#        passiveportrange => '49999:59999',
#      },
#    }
#
#
class pureftpd (
  Boolean $use_selinux  = false,
  Hash $config       = {},
  Hash $config_ldap  = {},
  Hash $config_mysql = {},
  Hash $config_pgsql = {},
) {

  include pureftpd::service

  class{ 'pureftpd::install': use_selinux => $use_selinux }

  if ! empty($config_ldap) {
    # insert the path to the ldap conf file into pure-ftpd.conf
    $enable_ldap = { ldapconfigfile => $pureftpd::params::ldap_conf_path }

    # instantiate a pureftpd::config::ldap that will notify the service class
    $safe_config_ldap = merge($config_ldap,
      { notify => Class[ 'pureftpd::service' ] }
    )
    create_resources( 'class',
      { 'pureftpd::config::ldap' => $safe_config_ldap }
    )

    # only try to create the ldap configuration file after the pureftpd package
    # is installed and configuration; otherwise the dir may not exist yet
    Class[ 'pureftpd::config' ] -> Class[ 'pureftpd::config::ldap' ]
  } else {
    $enable_ldap = undef
  }

  if ! empty($config_mysql) {
    # insert the path to the mysql conf file into pure-ftpd.conf
    $enable_mysql = { mysqlconfigfile => $pureftpd::params::mysql_conf_path }

    # instantiate a pureftpd::config::mysql that will notify the service class
    $safe_config_mysql = merge($config_mysql,
      { notify => Class[ 'pureftpd::service' ] }
    )
    create_resources( 'class',
      { 'pureftpd::config::mysql' => $safe_config_mysql }
    )

    # only try to create the mysql configuration file after the pureftpd package
    # is installed and configuration; otherwise the dir may not exist yet
    Class[ 'pureftpd::config' ] -> Class[ 'pureftpd::config::mysql' ]
  } else {
    $enable_mysql = undef
  }

  if ! empty($config_pgsql) {
    # insert the path to the pgsql conf file into pure-ftpd.conf
    $enable_pgsql = { pgsqlconfigfile => $pureftpd::params::pgsql_conf_path }

    # instantiate a pureftpd::config::mysql will notify the service class
    $safe_config_pgsql = merge($config_pgsql,
      { notify => Class[ 'pureftpd::service' ] }
    )
    create_resources( 'class',
      { 'pureftpd::config::pgsql' => $safe_config_pgsql }
    )

    # only try to create the pgsql configuration file after the pureftpd
    # package is installed and configuration; otherwise the dir may not exist
    # yet
    Class[ 'pureftpd::config' ] -> Class[ 'pureftpd::config::pgsql' ]
  } else {
    $enable_pgsql = undef
  }

  $safe_config = merge(
    $config,
    { notify => Class['pureftpd::service'] },
    $enable_ldap,
    $enable_mysql,
    $enable_pgsql
  )

  create_resources( 'class', { 'pureftpd::config' => $safe_config } )

  Class[ 'pureftpd::install' ] ->
  Class[ 'pureftpd::config' ] ->
  Class[ 'pureftpd::service' ] ->
  Class[ 'pureftpd' ]
}

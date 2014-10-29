# == Define pureftpd::config::item
#
# Full description of class pureftpd::config::item here
#
# === Authors
#
# Maxence Dunnewind <tech@typhon.com>
#
define pureftpd::config::item (){
  if inline_template('<%= scope.lookupvar("::pureftpd::safe_config[@title.downcase]") %>') != 'undef' {
    notice inline_template('<%= scope.lookupvar("::pureftpd::safe_config[@title.downcase]") %>') 
    file { "${pureftpd::params::conf_dir}/${title}":
      ensure  => file,
      content => template("${module_name}/${pureftpd::params::conf_erb}"),
      owner   => 'root',
      group   => 'root',
      mode    =>  '0644',
    }
  }
}


# Class: nginx::package::redhat
#
# This module manages NGINX package installation on RedHat based systems
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class nginx::package::redhat (
  $pkg_version,
  $manage_repo
) {

  if downcase($::operatingsystem) == 'redhat' {
    $os_type = 'rhel'
  } else {
    $os_type = downcase($::operatingsystem)
  }

  if $::lsbmajdistrelease == undef {
    $os_rel = regsubst($::operatingsystemrelease, '\..*$', '')
  } else {
    $os_rel = $::lsbmajdistrelease
  }

  if $manage_repo {
    yumrepo { 'nginx-release':
      baseurl  => "http://nginx.org/packages/${os_type}/${os_rel}/\$basearch/",
      descr    => 'nginx repo',
      enabled  => '1',
      gpgcheck => '0',
    }
  }

  package { 'nginx':
    ensure  => $pkg_version,
    require => Yumrepo['nginx-release'],
  }
}

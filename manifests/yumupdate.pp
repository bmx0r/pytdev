stage { pre: before => Stage[main] }
class yumupdate {
  $sentinel = "/tmp-updated"
  exec { "yum update":
    command => "/usr/bin/yum update -y  && touch ${sentinel}",
    onlyif => "/usr/bin/env test \\! -f ${sentinel}",
    timeout => 3600,
  }
  }

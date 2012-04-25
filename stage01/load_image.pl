#!/usr/bin/perl
use strict;

require "../lib/timed_run.pl";

open( INPUT, "< ../input/2b_tested.lst" ) or die $!;

my $distro = "";
my $version = "";
my $arch = "64";

my $line;

while( $line = <INPUT> ){
	chomp($line);
	if( $line =~ /^([\d\.]+)\t(.+)\t(.+)\t(\d+)\t(.+)\t\[(.+)\]/ ){
                print "IP $1 [Distro $2, Version $3, Arch $4] is built from $5 with Eucalyptus-$6\n";
		$distro = $2;
		$version = $3;
		$arch = $4;
	};
};

close(INPUT);

my $output = "";
my $err_str = "";

my $last_m = "";

if( $distro eq "UBUNTU" || $distro eq "DEBIAN" || $distro eq "FEDORA" || ( ($distro eq "RHEL" || $distro eq "CENTOS") && $version =~ /^6/ )  ){
	print "Distro $distro\n";
	print "Loading KVM images\n";
	#system("./doit.sh kvm");

	my $toed;
	if( $arch eq "64" ){
		$toed = timed_run("./doit.sh kvm", 900);		# 15 min deadline 
	}else{
		$toed = timed_run("./doit_i386.sh kvm", 900);                # 15 min deadline
	};

	$output = get_recent_outstr();
	$err_str = get_recent_errstr();

	print "\n################# STDOUT ##################\n";
        print $output . "\n";
        print "\n\n################# STDERR ##################\n";
        print $err_str . "\n";

	if( $toed ){
		print "LOAD IMAGE TIME-OUT !!\n";
		exit(1);
	};

	my @temp_arr = split( /\n/, $output );
	
	$last_m = @temp_arr[@temp_arr-1];

}elsif( $distro eq "OPENSUSE" || $distro eq "SLES" || ( ($distro eq "RHEL" || $distro eq "CENTOS") && $version =~ /^5/ ) ){
	print "Distro $distro\n";
        print "Loading XEN images\n";
	#system("./doit.sh xen");
	#$output = `./doit.sh xen | tail -n 1 `;

	my $toed;

        if( $arch eq "64" ){
                $toed = timed_run("./doit.sh xen", 900);                # 15 min deadline
        }else{
                $toed = timed_run("./doit_i386.sh xen", 900);                # 15 min deadline
        };

        $output = get_recent_outstr();
        $err_str = get_recent_errstr();

        print "\n################# STDOUT ##################\n";
        print $output . "\n";
        print "\n\n################# STDERR ##################\n";
        print $err_str . "\n";

        if( $toed ){
                print "LOAD IMAGE TIME-OUT !!\n";
                exit(1);
        };

        my @temp_arr = split( /\n/, $output );

        $last_m = @temp_arr[@temp_arr-1];	

}else{
	print "Distro $distro\n";
	print "WARN : UNKNOWN DISTRO !!\n";
        print "Loading KVM images\n";
	#system("./doit.sh kvm");
	#$output = `./doit.sh kvm | tail -n 1 `;

        my $toed = timed_run("./doit.sh kvm", 900);             # 15 min deadline

        $output = get_recent_outstr();
        $err_str = get_recent_errstr();

        print "\n################# STDOUT ##################\n";
        print $output . "\n";
        print "\n\n################# STDERR ##################\n";
        print $err_str . "\n";

        if( $toed ){
                print "LOAD IMAGE TIME-OUT !!\n";
                exit(1);
        };

        my @temp_arr = split( /\n/, $output );

        $last_m = @temp_arr[@temp_arr-1];

};

if( $last_m =~ /eki(.+)\s+eri(.+)\semi(.+)/ ){
	print "Last Message : $last_m\n";
	print "LOAD IMAGE has completed\n";
	exit(0);
}else{
	print "LOAD IMAGE has FAILED !!\n";
	exit(1);
};

exit(1);

1;



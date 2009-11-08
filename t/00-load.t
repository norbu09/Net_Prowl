#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Net::Prowl' );
}

diag( "Testing Net::Prowl $Net::Prowl::VERSION, Perl $], $^X" );

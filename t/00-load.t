#!perl -T

use 5.010001;
use strict;
use warnings;

use Test::More tests => 2;

use HTML::Tidy5;
use HTML::Tidy5::Message;
use Test::HTML::Tidy5;

my $ver = HTML::Tidy5->tidy_library_version;

diag( "Testing HTML::Tidy5 $HTML::Tidy5::VERSION, tidy $ver, Perl $], $^X" );

is( $Test::HTML::Tidy5::VERSION, $HTML::Tidy5::VERSION, 'HTML::Tidy5 and Test::HTML::Tidy5 versions must match' );

# Do my own version matching.
my @parts = split( /\./, $ver );
my $ok = ( $parts[0] == 5 );
if ( $ok ) {
    if ( $parts[1] < 7 ) {
        $ok = 0;
    }
    elsif ( $parts[1] == 7 ) {
        $ok = ($parts[2] >= 17);
    }
}

ok( $ok, "Must have tidy version 5.7.17 or higher but you have $ver" );

exit 0;

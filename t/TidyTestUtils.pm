package TidyTestUtils;

use 5.020000;
use warnings;
use strict;
use experimental 'signatures';

use Test::More;

use base 'Exporter';

our @EXPORT_OK = qw(
    remove_specificity
    messages_are
);
our @EXPORT = @EXPORT_OK;

sub remove_specificity {
    my $clean = shift;

    $clean =~ s/HTML Tidy for HTML5 (for .+ )?\bversion \d+\.\d+\.\d+/TIDY/;

    return $clean;
}


sub messages_are( $tidy, $exp, $msg = undef ) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $got = [ map { $_->as_string } $tidy->messages ];
    my $ok = is_deeply( $got, $exp, $msg );
    if ( !$ok ) {
        diag(explain($got));
        diag(explain($exp));
    }

    return $ok;
}


1;

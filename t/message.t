#!perl -T

use 5.20.3;
use warnings;
use strict;
use experimental 'signatures';
use experimental 'postderef';

use Test::More tests => 8;

use HTML::Tidy5;
use HTML::Tidy5::Message;

WITH_LINE_NUMBERS_WITH_FILENAME: {
    my $error = HTML::Tidy5::Message->new( 'foo.pl', TIDY_ERROR, 2112, 5150, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy5::Message' );

    my %expected = (
        file        => 'foo.pl',
        type        => TIDY_ERROR,
        line        => 2112,
        column      => 5150,
        text        => 'Blah blah',
        as_string   => 'foo.pl (2112:5150) Error: Blah blah',
    );
    _match_up( $error, \%expected, 'With line numbers' );
}

WITH_LINE_NUMBERS_WITHOUT_FILENAME: {
    my $error = HTML::Tidy5::Message->new( undef, TIDY_ERROR, 2112, 5150, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy5::Message' );

    my %expected = (
        file        => undef,
        type        => TIDY_ERROR,
        line        => 2112,
        column      => 5150,
        text        => 'Blah blah',
        as_string   => '(2112:5150) Error: Blah blah',
    );
    _match_up( $error, \%expected, 'With line numbers' );
}

WITHOUT_LINE_NUMBERS_WITH_FILENAME: {
    my $error = HTML::Tidy5::Message->new( 'bar.pl', TIDY_WARNING, undef, undef, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy5::Message' );

    my %expected = (
        file        => 'bar.pl',
        type        => TIDY_WARNING,
        line        => undef,
        column      => undef,
        text        => 'Blah blah',
        as_string   => 'bar.pl Warning: Blah blah',
    );
    _match_up( $error, \%expected, 'Without line numbers' );
}

WITHOUT_LINE_NUMBERS_WITHOUT_FILENAME: {
    my $error = HTML::Tidy5::Message->new( undef, TIDY_WARNING, undef, undef, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy5::Message' );

    my %expected = (
        file        => undef,
        type        => TIDY_WARNING,
        line        => undef,
        column      => undef,
        text        => 'Blah blah',
        as_string   => 'Warning: Blah blah',
    );
    _match_up( $error, \%expected, 'Without line numbers' );
}


sub _match_up( $error, $exp, $msg ) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return subtest "_matchup( $msg )" => sub {
        plan tests => scalar keys $exp->%*;

        for my $what ( sort keys $exp->%* ) {
            is( $error->$what, $exp->{$what}, "$what matches" );
        }
    };
}


exit 0;

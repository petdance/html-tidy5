#!perl -T

use 5.010001;
use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy5;

use lib 't';

use TidyTestUtils;

my $html = <<'HTML';
<!DOCTYPE html>
<html>
    <head>
        <title></title>
    </head>
    <body id=foo>
    </body>
</html>
HTML

subtest 'default constructor shows info' => sub {
    plan tests => 2;

    my $tidy = HTML::Tidy5->new;
    isa_ok( $tidy, 'HTML::Tidy5' );
    $tidy->parse( 'test', $html );

    messages_are( $tidy,
        [
            'test (6:5) Info: value for attribute "id" missing quote marks',
            'test (4:9) Warning: blank \'title\' element',
        ]
    );
};

subtest 'show_info => 1 shows info' => sub {
    plan tests => 2;

    my $tidy = HTML::Tidy5->new( { show_info => 1 } );
    isa_ok( $tidy, 'HTML::Tidy5' );
    $tidy->parse( 'test', $html );

    messages_are( $tidy,
        [
            'test (6:5) Info: value for attribute "id" missing quote marks',
            'test (4:9) Warning: blank \'title\' element',
        ]
    );
};

subtest 'show_info => 0' => sub {
    plan tests => 2;

    my $tidy = HTML::Tidy5->new( { show_info => 0 } );
    isa_ok( $tidy, 'HTML::Tidy5' );
    $tidy->parse( 'test', $html );

    messages_are( $tidy,
        [
            'test (4:9) Warning: blank \'title\' element',
        ]
    );
};

exit 0;

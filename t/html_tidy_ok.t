#!perl

use warnings;
use strict;

use Test::More tests => 3;

use Test::Builder::Tester;
use Test::HTML::Tidy5;

subtest 'html_tidy_ok without errors' => sub {
    plan tests => 1;

    my $html = <<'HTML';
<!DOCTYPE html>
<html>
    <head>
        <title> </title>
    </head>
    <body>
        <p>
            This is a valid fragment (with some errors), but an incomplete document.
            <img src="alpha.jpg" height="21" width="12" alt="alpha">
            <input type="image">
        </p>
    </body>
</html>
HTML

    test_out( 'ok 1 - Called html_tidy_ok on full document' );
    html_tidy_ok( $html, 'Called html_tidy_ok on full document' );
    test_test( 'html_tidy_ok on full document works' );
};


subtest 'html_tidy_ok with failures' => sub {
    plan tests => 1;

    my $html = <<'HTML';
<p>
    This is a valid fragment (with some errors), but an incomplete document.
    <img src="alpha.jpg" height="21" width="12">
    <input type="image">
</p>
<p>
HTML

    test_out( 'not ok 1 - Called html_tidy_ok on fragment' );
    test_fail( +8 );
    test_diag( 'Errors: Called html_tidy_ok on fragment' );
    test_diag( '(1:1) Warning: missing <!DOCTYPE> declaration' );
    test_diag( '(1:1) Warning: inserting implicit <body>' );
    test_diag( '(1:1) Warning: inserting missing \'title\' element' );
    test_diag( '(3:5) Warning: <img> lacks "alt" attribute' );
    test_diag( '(6:1) Warning: trimming empty <p>' );
    test_diag( '5 messages on the page' );
    html_tidy_ok( $html, 'Called html_tidy_ok on fragment' );
    test_test( 'html_tidy_ok works on fragment' );
};


subtest 'Test passing our own Tidy object' => sub {
    plan tests => 2;

    my $html = <<'HTML';
<!DOCTYPE html>
<html>
    <head>
        <title> </title>
    </head>
    <body>
        <p>
            This is a valid fragment (with some errors), but an incomplete document.
            <img src="alpha.jpg" height="21" width="12" alt="alpha">
            <input type="image">
        </p>
        <p>
    </body>
</html>
HTML

    # Default html_tidy_ok() complains about empty paragraph.
    test_out( 'not ok 1 - Empty paragraph' );
    test_fail( +4 );
    test_diag( 'Errors: Empty paragraph' );
    test_diag( '(12:9) Warning: trimming empty <p>' );
    test_diag( '1 message on the page' );
    html_tidy_ok( $html, 'Empty paragraph' );
    test_test( 'html_tidy_ok works on empty paragraph' );

    # Now make our own more relaxed Tidy object and it should pass.
    my $tidy = HTML::Tidy5->new( { drop_empty_elements => 0 } );
    test_out( 'ok 1 - Relaxed tidy' );
    html_tidy_ok( $tidy, $html, 'Relaxed tidy' );
    test_test( 'html_tidy_ok with user-specified tidy works' );
};



done_testing();
exit 0;

#!perl -T

use 5.20.3;
use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy5;

my $html = join '', <DATA>;

my $tidy = HTML::Tidy5->new;
isa_ok( $tidy, 'HTML::Tidy5' );
$tidy->ignore( type => TIDY_INFO );
my $rc = $tidy->parse( '-', $html );
ok( $rc, 'Parsed OK' );

my @got = map { $_->as_string } $tidy->messages;
is_deeply(
    \@got,
    [
        '- (3:5) Warning: too many title elements in <head>',
    ]
);

exit 0;

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <HEAD>
        <TITLE>Test stuff</TITLE>
        <TITLE>As if one title isn't enough</TITLE>
    </HEAD>
    <BODY BGCOLOR="white">
        <P>This is my paragraph</P>
    </BODY>
</HTML>

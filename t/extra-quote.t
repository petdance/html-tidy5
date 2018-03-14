#!perl -T

use 5.010001;
use warnings;
use strict;

# Response to an HTML::Lint request that it handle mishandled quotes.
# See https://rt.cpan.org/Ticket/Display.html?id=1459

use Test::More tests => 4;

use HTML::Tidy5;

my $html = do { local $/ = undef; <DATA> };

my $tidy = HTML::Tidy5->new;
isa_ok( $tidy, 'HTML::Tidy5' );

$tidy->ignore( text => qr/DOCTYPE/ );
my $rc = $tidy->parse( '-', $html );
ok( $rc, 'Parsed OK' );

my @expected = split /\n/, <<'HERE';
- (4:1) Warning: <img> unexpected or duplicate quote mark
- (4:1) Warning: <img> escaping malformed URI reference
- (4:1) Warning: <img> illegal characters found in URI
- (4:1) Warning: <img> lacks "alt" attribute
HERE

chomp @expected;

my @messages = $tidy->messages;
is( scalar @messages, 4, 'Should have exactly three messages' );

my @strings = map { $_->as_string } @messages;
s/[\r\n]+\z// for @strings;
is_deeply( \@strings, \@expected, 'Matching warnings' );

__DATA__
<html>
<title>Bogo</title>
<body>
<img src="foo alt="">
</body>
</html>

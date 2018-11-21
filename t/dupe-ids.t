#!perl -T

use 5.010001;
use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy5;

my $tidy = HTML::Tidy5->new;
isa_ok( $tidy, 'HTML::Tidy5' );
my $rc = $tidy->parse( '-', <DATA> );
ok( $rc, 'Parsed OK' );

my @expected = split /\n/, <<'HERE';
- (11:9) Warning: <div> anchor "foo" already defined
- (12:9) Warning: <span> anchor "foo" already defined
- (15:9) Warning: <div> anchor "foo99" already defined
- (16:9) Warning: <span> anchor "foo99" already defined
- (19:9) Warning: <div> anchor "Foo" already defined
- (20:9) Warning: <span> anchor "Foo" already defined
- (23:9) Warning: <div> anchor "FOO" already defined
- (24:9) Warning: <span> anchor "FOO" already defined
- (26:9) Warning: <a> anchor "foo" already defined
- (27:9) Warning: <a> anchor "foo" already defined
- (28:9) Warning: <a> anchor "foo" already defined
- (30:9) Warning: <a> anchor "FOO" already defined
- (31:9) Warning: <a> anchor "FOO" already defined
- (32:9) Warning: <a> anchor "FOO" already defined
HERE
chomp @expected;

my @messages = map { $_->as_string } $tidy->messages;
is_deeply( \@messages, \@expected, 'Messages match' );

__DATA__
<!DOCTYPE html>
<html>
    <head>
        <title>Tidy should detect dupe IDs even if they have uppercase letters.</title>
    </head>
    <body>
        <p>
            This test exercises <a href="https://github.com/htacg/tidy-html5/issues/726">issue 726 in tidy5-html5</a>.
        </p>
        <p    id="foo">1</p>
        <div  id="foo">2</div>
        <span id="foo">3</span>

        <p    id="foo99">1</p>
        <div  id="foo99">2</div>
        <span id="foo99">3</span>

        <p    id="Foo">1</p>
        <div  id="Foo">2</div>
        <span id="Foo">3</span>

        <p    id="FOO">1</p>
        <div  id="FOO">2</div>
        <span id="FOO">3</span>

        <a name="foo">1</a>
        <a name="foo">2</a>
        <a name="foo">3</a>

        <a name="FOO">1</a>
        <a name="FOO">2</a>
        <a name="FOO">3</a>
    </body>
</html>

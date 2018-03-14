#!perl -T

use 5.010001;
use strict;
use warnings;

use Test::Exception;
use Test::More;

use HTML::Tidy5;

my @unsupported_options = qw(
    force-output
    gnu-emacs-file
    gnu-emacs
    keep-time
    quiet
    slide-style
    write-back
);

foreach my $option ( @unsupported_options ) {
    throws_ok {
        HTML::Tidy5->new(
            {
                config_file => 't/cfg-for-parse.cfg',
                $option     => 1,
            },
        );
    } qr/\QUnsupported option: $option\E/,
    "option $option is not supported";
}

done_testing();

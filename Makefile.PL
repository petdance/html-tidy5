#!/usr/bin/perl

package main;

use 5.010001;
use strict;
use warnings;
use ExtUtils::MakeMaker 6.48;
use ExtUtils::Liblist;
use Config;
use Alien::Base::Wrapper qw/ Alien::TidyHTML5 !export /;

if ( not eval { require LWP::Simple; 1; } ) {
    print <<'EOF';

NOTE: It seems that you don't have LWP::Simple installed.
      The webtidy program will not be able to retrieve web pages.

EOF
}

my $parms = {
    NAME                => 'HTML::Tidy5',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'lib/HTML/Tidy5.pm',
    ABSTRACT_FROM       => 'lib/HTML/Tidy5.pm',
    PREREQ_PM           => {
        'Encode'          => 0,   # for tests
        'Exporter'        => 0,
        'Getopt::Long'    => 0,   # in webtidy
        'Test::More'      => '0.98', # For subtest()
        'Test::Builder'   => 0,
        'Test::Exception' => 0,
        'Carp'            => 0,
        'constant'        => 0,
    },

    MIN_PERL_VERSION    => 5.010001,
    LICENSE             => 'artistic_2',
    META_MERGE => {
        resources => {
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0.php',
            homepage    => 'http://github.com/petdance/html-tidy5',
            bugtracker  => 'http://github.com/petdance/html-tidy5/issues',
            repository  => 'http://github.com/petdance/html-tidy5',
        },
    },

    CONFIGURE_REQUIRES => {
        'Alien::Base::Wrapper' => '0',
        'Alien::TidyHTML5'     => '0',
    },
    Alien::Base::Wrapper->mm_args,

    EXE_FILES           => [qw(bin/webtidy5)],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTML-Tidy5-*' },
};

WriteMakefile( %{$parms} );

sub MY::postamble { ## no critic ( Subroutines::ProhibitQualifiedSubDeclarations )
return <<'MAKE_FRAG';
.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib --exclude=t/lib \
		--exclude=.svn --exclude='*~' \
		--languages=C,Perl --langmap=Perl:+.t \
		.

critic:
	perlcritic -1 \
		-profile perlcriticrc \
		.

MAKE_FRAG
}

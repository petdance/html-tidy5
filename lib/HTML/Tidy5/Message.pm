package HTML::Tidy5::Message;

use 5.020000;
use warnings;
use strict;
use experimental 'signatures';

=head1 NAME

HTML::Tidy5::Message - Message object for the Tidy functionality

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

Almost everything is an accessor.

=head2 new( $file, $line, $column, $text )

Create an object.  It's not very exciting.

C<$file> can be C<undef> or an empty string, in which case it will not appear in messages.

=cut

sub new( $class, $file, $type, $line, $column, $text ) {
    # Add an element that says what tag caused the error (B, TR, etc)
    # so that we can match 'em up down the road.
    my $self  = {
        _file   => $file,
        _type   => $type,
        _line   => $line,
        _column => $column,
        _text   => $text,
    };

    bless $self, $class;

    return $self;
}


=head2 as_string()

Returns a nicely-formatted string for printing out to stdout or some similar user thing.

=cut

sub as_string( $self ) {
    my %strings = (
        1 => 'Info',
        2 => 'Warning',
        3 => 'Error',
    );

    my $msg = $strings{$self->type} . ': ' . $self->text;

    if ( $self->line && $self->column ) {
        $msg = sprintf( '(%d:%d) %s', $self->line, $self->column, $msg );
    }

    my $file = $self->file // '';
    if ( $file ne '' ) {
        $msg = "$file $msg";
    }

    return $msg;
}


=head2 file()

Returns the filename of the error, as set by the caller.

=head2 type()

Returns the type of the error.  This will either be C<TIDY_ERROR>,
or C<TIDY_WARNING>.

=head2 line()

Returns the line number of the error, or 0 if there isn't an applicable
line number.

=head2 column()

Returns the column number, or 0 if there isn't an applicable column
number.

=head2 text()

Returns the text of the message.  This does not include a type string,
like "Info: ".

=cut

sub file( $self )   { return $self->{_file} }
sub type( $self )   { return $self->{_type} }
sub line( $self )   { return $self->{_line} }
sub column( $self ) { return $self->{_column} }
sub text( $self )   { return $self->{_text} }


=head1 COPYRIGHT & LICENSE

Copyright 2005-2024 Andy Lester.

This program is free software; you can redistribute it and/or modify
it under the terms of the Artistic License v2.0.

=head1 AUTHOR

Andy Lester, C<< <andy@petdance.com> >>

=cut


1; # happy

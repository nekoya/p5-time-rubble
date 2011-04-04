package Time::Rubble;
use strict;
use warnings;

our $VERSION = '0.01';

use Carp;

sub new {
    my ($class, $args) = @_;
    my $now = time;
    if ($args) {
        if ($args =~ /^\d+$/) {
            $now = $args;
        } else {
            Carp::croak "$args is invalid argument";
        }
    }
    bless {
        epoch => $now,
    }, $class;
}

1;
__END__

=head1 NAME

Time::Rubble - 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item new

=back

=head1 AUTHOR

Ryo Miyake E<lt>ryo.studiom {at} gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

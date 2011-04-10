package Time::Rubble;
use strict;
use warnings;

our $VERSION = '0.01';

use Carp;
use Time::Piece;

sub epoch { $_[0]->{epoch} }

sub new {
    my ($class, $args) = @_;
    if ($args) {
        if (ref $args eq 'HASH') {
        } elsif ($args =~ /^\d+$/) {
            $args = { now => $args };
        } else {
            Carp::croak "invalid argument";
        }
    }
    bless {
        epoch    => $args->{now}      || time,
        timezone => $args->{timezone} || 'UTC',
    }, $class;
}

use overload '""'  => \&epoch,
             'cmp' => \&compare,
             '<=>' => \&compare,
             '+'   => \&add,
             '-'   => \&subtract,
             'fallback' => undef;

sub _get_epochs {
    my ($lhs, $rhs, $reverse) = @_;
    $rhs = $rhs->{epoch} if ref $rhs eq 'Time::Rubble';
    if ($reverse) {
        return $rhs, $lhs->{epoch};
    }
    return $lhs->{epoch}, $rhs;
}

sub compare {
    my ($lhs, $rhs) = _get_epochs(@_);
    return $lhs <=> $rhs;
}

sub add      { shift->{epoch} + shift }
sub subtract { shift->{epoch} - shift }

sub mysql_datetime {
    my $self = shift;
    local $ENV{TZ} = $self->{timezone};
    my $t = localtime($self->{epoch});
    $t->strftime('%Y-%m-%d %H:%M:%S');
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

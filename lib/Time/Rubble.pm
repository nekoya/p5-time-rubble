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

sub _time_piece {
    my $self = shift;
    local $ENV{TZ} = $self->{timezone};
    my $t = localtime($self->{epoch});
}

sub year   { shift->_time_piece->year }
sub mon    { shift->_time_piece->mon  }
sub day    { shift->_time_piece->mday } # not compatible Time::Piece
sub mday   { shift->_time_piece->mday }
sub hour   { shift->_time_piece->hour }
sub minute { shift->_time_piece->minute }
sub min    { shift->_time_piece->min  }
sub second { shift->_time_piece->second }
sub sec    { shift->_time_piece->sec  }
sub mysql_datetime { shift->_to_str('%Y-%m-%d %H:%M:%S') }
sub strftime {
    my ($self, $format) = @_;
    shift->_time_piece->strftime($format);
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

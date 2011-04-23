package Time::Rubble;
use strict;
use warnings;

our $VERSION = '0.01';

use Carp;
use Time::Piece::MySQL;

sub new {
    my ($class, $dt, $tz) = @_;
    $dt ||= time;
    $tz ||= 'UTC';

    $dt .= ' 00:00:00' if $dt =~ /^\d\d\d\d\-\d\d\-\d\d$/;
    if ($dt =~ /^\d\d\d\d\-\d\d\-\d\d \d\d:\d\d:\d\d$/) {
        local $ENV{TZ} = $tz;
        $dt = localtime->from_mysql_datetime($dt)->epoch;
    }

    Carp::croak "$dt is invalid time" unless $dt =~ /^[0-9]+$/;

    bless {
        epoch    => $dt,
        timezone => $tz,
    }, $class;
}

use overload '""'  => \&epoch,
             'cmp' => \&compare,
             '<=>' => \&compare,
             '+'   => \&add,
             '-'   => \&subtract,
             'fallback' => undef;

sub epoch { $_[0]->{epoch} }

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
    my $key = join ':', $self->{epoch}, $self->{timezone};
    unless ($self->{_cache}->{$key}) {
        local $ENV{TZ} = $self->{timezone};
        $self->{_cache}->{$key} = localtime($self->{epoch});
    }
    $self->{_cache}->{$key};
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
sub mysql_datetime { shift->_time_piece->strftime('%Y-%m-%d %H:%M:%S') }
sub strftime {
    my ($self, $format) = @_;
    shift->_time_piece->strftime($format);
}

1;
__END__

=head1 NAME

Time::Rubble - Simple epoch time manager with time zone support

=head1 SYNOPSIS

    my $now = Time::Rubble->new;
    $now->mysql_datetime;

    my $dt = Time::Rubble->new('2011-04-12 09:24:53', 'JST-9');
    $dt->{timezone} = 'UTC';
    $dt->strftime('%Y-%m-%d');

=head1 DESCRIPTION

B<Time::Rubble> is a simple module based on epoch time. It can be converted as string by any formats with timezone.

B<Time::Rubble> delegates their work to Time::Piece to get time as string.

=head1 METHODS

=over 4

=item new

=item new($time)

=item new($time, $timezone)

$time takes two types of format, epoch or mysql_datetime (default: current time).

$timezone affects when the object is converted to string (default: UTC).

=item year

=item mon

=item day

=item mday

=item hour

=item minute

=item min

=item second

=item sec

These works like L<Time::Piece>'s methods.  Actually, B<Time::Rubble> creates B<Time::Piece> object.

But, day method is not compatible with B<Time::Piece>. Its behavior is same to mday method.

=item mysql_datetime

Get MySQL datetime format like L<Time::Piece::MySQL>.

=item strftime($format)

Wrapper of B<Time::Piece>'s strftime.

=back

=head1 AUTHOR

Ryo Miyake E<lt>ryo.studiom {at} gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

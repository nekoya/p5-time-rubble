use strict;
use warnings;
use Test::More;

use Time::Rubble;

my $now = 1301931927;
my $t = Time::Rubble->new($now);

my $scalar = $t;
is $scalar, $now, '\'""\'';;

cmp_ok $t, 'eq', $now, 'cmp';
cmp_ok $t, '==', $now, '<=>';

my $add = $t + 10;
is $add, $now + 10, '+';

my $sub = $t - 10;
is $sub, $now - 10, '-';

done_testing;

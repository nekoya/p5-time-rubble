use strict;
use warnings;
use Test::More;

use Time::Rubble;

my $now = 1301931927;

my $t = Time::Rubble->new($now);
is $t->mysql_datetime, '2011-04-04 15:45:27', 'UTC datetime';

$t->{timezone} = 'JST-9';
is $t->mysql_datetime, '2011-04-05 00:45:27', 'JST datetime';

done_testing;

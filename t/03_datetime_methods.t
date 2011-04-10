use strict;
use warnings;
use Test::More;

use Time::Rubble;

my $now = 1301931927;

subtest "UTC" => sub {
    my $t = Time::Rubble->new($now);
    is $t->year, 2011, 'year';
    is $t->mon,     4, 'month';
    is $t->day,     4, 'day';
    is $t->hour,   15, 'hour';
    is $t->minute, 45, 'minute';
    is $t->min,    45, 'min is alias of minute';
    is $t->second, 27, 'second';
    is $t->sec,    27, 'sec is alias of second';
    is $t->mysql_datetime, '2011-04-04 15:45:27', 'mysql_datetime';
    is $t->strftime('%Y/%m/%d %H:%M:%S'), '2011/04/04 15:45:27', 'strftime';
};

subtest "JST" => sub {
    my $t = Time::Rubble->new({ now => $now, timezone => 'JST-9' });
    is $t->year, 2011, 'year';
    is $t->mon,     4, 'month';
    is $t->day,     5, 'day';
    is $t->hour,    0, 'hour';
    is $t->minute, 45, 'minute';
    is $t->min,    45, 'min is alias of minute';
    is $t->second, 27, 'second';
    is $t->sec,    27, 'sec is alias of second';
    is $t->mysql_datetime, '2011-04-05 00:45:27', 'mysql_datetime';
    is $t->strftime('%Y/%m/%d %H:%M:%S'), '2011/04/05 00:45:27', 'strftime';
};

done_testing;

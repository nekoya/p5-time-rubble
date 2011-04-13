use strict;
use warnings;
use Test::More;

use Time::Rubble;

my $now = 1301931927;

subtest "cache key" => sub {
    my $t = Time::Rubble->new($now);
    ok $t->year;
    is_deeply [sort keys %{$t->{_cache}}], ["$now\:UTC"];

    $t->{timezone} = 'JST-9';
    ok $t->year;
    is_deeply [sort keys %{$t->{_cache}}], ["$now\:JST-9", "$now\:UTC"];

    $t->{epoch} -= 100;
    ok $t->year;
    is_deeply [sort keys %{$t->{_cache}}], [ $now - 100 . ':JST-9', "$now\:JST-9", "$now\:UTC"];
};

subtest "cache each timezone" => sub {
    my $t = Time::Rubble->new($now);
    is $t->mysql_datetime, '2011-04-04 15:45:27', 'UTC';
    $t->{timezone} = 'UTC+1';
    is $t->mysql_datetime, '2011-04-04 14:45:27', 'UTC+1';
    $t->{timezone} = 'JST-9';
    is $t->mysql_datetime, '2011-04-05 00:45:27', 'JST-9';

    $t->{timezone} = 'UTC';
    is $t->mysql_datetime, '2011-04-04 15:45:27', 'cached UTC';
    $t->{timezone} = 'UTC+1';
    is $t->mysql_datetime, '2011-04-04 14:45:27', 'cached UTC+1';
    $t->{timezone} = 'JST-9';
    is $t->mysql_datetime, '2011-04-05 00:45:27', 'cached JST-9';
};

done_testing;

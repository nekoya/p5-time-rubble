use strict;
use warnings;
use Test::More;

use Time::Rubble;

my $now = 1301931927;

my $t = Time::Rubble->new($now);
ok $t->year;
is_deeply [sort keys %{$t->{_cache}}], ["$now\:UTC"];

$t->{timezone} = 'JST-9';
ok $t->year;
is_deeply [sort keys %{$t->{_cache}}], ["$now\:JST-9", "$now\:UTC"];

$t->{epoch} -= 100;
ok $t->year;
is_deeply [sort keys %{$t->{_cache}}], [ $now - 100 . ':JST-9', "$now\:JST-9", "$now\:UTC"];

done_testing;

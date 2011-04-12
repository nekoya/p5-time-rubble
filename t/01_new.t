use strict;
use warnings;
use Test::More;
use Test::Exception;

use Time::Rubble;

my $now = 1301931927;

subtest "from current time (default)" => sub {
    ok my $t = Time::Rubble->new;
    isa_ok $t, 'Time::Rubble';
    like $t->{epoch} - time, qr/^(0|1)$/;
    is $t->{timezone}, 'UTC';
};

subtest "from epoch" => sub {
    ok my $t = Time::Rubble->new($now);
    is $t->{epoch}, $now;
    is $t->{timezone}, 'UTC';
};

subtest "from epoch with timezone" => sub {
    ok my $t = Time::Rubble->new($now, 'JST-9');
    is $t->{epoch}, $now;
    is $t->{timezone}, 'JST-9';
};

subtest "from mysql_datetime" => sub {
    ok my $t = Time::Rubble->new('2011-04-04 15:45:27');
    is $t->{epoch}, $now;
    is $t->{timezone}, 'UTC';
};

subtest "from mysql_datetime with timezone" => sub {
    ok my $t = Time::Rubble->new('2011-04-05 00:45:27', 'JST-9');
    is $t->{epoch}, $now;
    is $t->{timezone}, 'JST-9';
};

subtest "invalid arg" => sub {
    throws_ok { Time::Rubble->new('hoge') } qr/^hoge is invalid time/;
};

done_testing;

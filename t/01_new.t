use strict;
use warnings;
use Test::More;
use Test::Exception;

use Time::Rubble;

my $now = 1301931927;

subtest "from current time (default)" => sub {
    ok my $t = Time::Rubble->new;
    like $t->{epoch} - time, qr/^(0|1)$/;
};

subtest "from epoch" => sub {
    ok my $t = Time::Rubble->new($now);
    is $t->{epoch}, $now;
};

subtest "invalid arg" => sub {
    throws_ok { Time::Rubble->new('hoge') } qr/^invalid argument/;
};

subtest "hash arg" => sub {
    my $args = {
        now      => $now,
        timezone => 'JST-9',
    };
    ok my $t = Time::Rubble->new($args), 'created instance';
    is $t->{epoch}, $now, 'assert epoch';
    is $t->{timezone}, 'JST-9', 'assert timezone';
};

done_testing;

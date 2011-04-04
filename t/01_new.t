use strict;
use warnings;
use Test::More;
use Test::Exception;

use Time::Rubble;

subtest "from current time (default)" => sub {
    my $now = time;
    ok my $t = Time::Rubble->new;
    like $t->{epoch} - $now, qr/^(0|1)$/;
};

subtest "from epoch" => sub {
    my $now = 1301931927;
    ok my $t = Time::Rubble->new($now);
    is $t->{epoch}, $now;
};

subtest "invalid arg" => sub {
    throws_ok { Time::Rubble->new('hoge') } qr/^hoge is invalid argument/;
};

done_testing;

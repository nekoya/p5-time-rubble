use inc::Module::Install;
name 'Time-Rubble';
all_from 'lib/Time/Rubble.pm';

requires 'Time::Piece' => '1.20';
requires 'Time::Piece::MySQL';

author_tests('xt');

test_requires 'Test::More';
test_requires 'Test::Exception';

WriteAll;

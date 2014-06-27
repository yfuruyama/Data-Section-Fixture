use strict;
use warnings;
use Test::More;
use Data::Section::Fixture qw(with_fixture);
use t::DB;

my $dbh = t::DB::dbh();

subtest 'SET statement can be executed' => sub {
    with_fixture($dbh, sub {
        my $row = $dbh->selectrow_arrayref('SELECT a, b FROM t');
        is_deeply $row, [10, 'bar'];
    });
};

done_testing;

__DATA__
@@ setup
CREATE TABLE t (a int, b varchar(16));
SET @a = 10;
SET @b = 'bar';
INSERT INTO t (a, b) VALUES (@a, @b);

@@ teardown
DROP TABLE t;

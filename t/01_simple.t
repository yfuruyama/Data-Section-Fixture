use strict;
use warnings;
use Test::More;
use Data::Section::Fixture qw(with_fixture);
use t::DB;

my $dbh = t::DB::dbh();

subtest 'fixture exists inside with_fixture' => sub {
    with_fixture($dbh, sub {
        my $rows = $dbh->selectall_arrayref('SELECT a FROM t ORDER BY a');
        is_deeply $rows, [[1], [2], [3]];
    });
};

subtest 'fixture does not exist outside with_fixture' => sub {
    # check table 't' doesn't exist
    my $sth = $dbh->table_info('', '', 't', 'TABLE');
    $sth->execute;
    my $row = $sth->fetchrow_array;
    is $row, undef;

    with_fixture($dbh, sub {});

    # check table 't' doesn't exist
    $sth = $dbh->table_info('', '', 't', 'TABLE');
    $sth->execute;
    $row = $sth->fetchrow_array;
    is $row, undef;
};

done_testing;

__DATA__
@@ setup
CREATE TABLE t (a int);
INSERT INTO t (a) VALUES (1), (2), (3);

@@ teardown
DROP TABLE t;

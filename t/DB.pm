package t::DB;

use strict;
use warnings;
use DBI;
use Test::More;
use Test::mysqld;

# declare package variable to prevent to be DESTROYed.
our $mysqld;
sub dbh {
    return $mysqld if $mysqld;

    $mysqld = Test::mysqld->new(
        my_cnf => {
            'skip_networking' => '',
        }
    ) or plan skip_all => $Test::mysqld::errstr;

    return DBI->connect(
        $mysqld->dsn(dbname => 'test')
    );
}

1;

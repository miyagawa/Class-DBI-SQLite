package Film;
use strict;

use File::Temp qw(tempdir tempfile);
my $dir = tempdir( CLEANUP => 1 );
my($fh, $filename) = tempfile( DIR => $dir );

use base qw(Class::DBI::SQLite);
__PACKAGE__->set_db('Main', "dbi:SQLite:dbname=$filename", '', '');
__PACKAGE__->table('Movies');
__PACKAGE__->columns(Primary => qw(id));
__PACKAGE__->columns(All => qw(id title director));

sub CONSTRUCT {
    my $class = shift;
    $class->db_Main->do(<<'SQL');
CREATE TABLE Movies (
    id INTEGER NOT NULL PRIMARY KEY,
    title VARCHAR(32) NOT NULL,
    director VARCHAR(64) NOT NULL
)
SQL
    ;
}

1;

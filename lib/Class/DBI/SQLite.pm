package Class::DBI::SQLite;

use strict;
use vars qw($VERSION);
$VERSION = 0.06;

require Class::DBI;
use base qw(Class::DBI);
use SQL::Statement;

sub _auto_increment_value {
    my $self = shift;
    return $self->db_Main->func("last_insert_rowid");
}

sub set_up_table {
    my($class, $table) = @_;

    # find all columns.
    my $sth = $class->db_Main->prepare("PRAGMA table_info('$table')");
    $sth->execute();
    my @columns;
    while (my $row = $sth->fetchrow_hashref) {
	push @columns, $row->{name};
    }
    $sth->finish;

    # find primary key. so complex ;-(
    $sth = $class->db_Main->prepare(<<'SQL');
SELECT sql FROM sqlite_master WHERE tbl_name = ?
SQL
    $sth->execute($table);
    my($sql) = $sth->fetchrow_array;
    $sth->finish;

    my $parser = SQL::Parser->new('AnyData', { RaiseError => 1});
    $parser->feature("valid_data_types","TIMESTAMP",1);
    $parser->parse($sql);
    my $structure = $parser->structure;
    my $primary;
    foreach my $key (keys %{$structure->{column_defs}}) {
	my $def = $structure->{column_defs}->{$key};
	next unless $def->{constraints};
	foreach my $constraint(@{$def->{constraints}}) {
	    if (uc($constraint) eq 'PRIMARY KEY') {
		$primary = $key;
		last;
	    }
	}
    }
    $class->table($table);
    $class->columns(All => @columns);
    $class->columns(Primary => $primary);
}

1;

__END__

=head1 NAME

Class::DBI::SQLite - Extension to Class::DBI for sqlite

=head1 SYNOPSIS

  package Film;
  use base qw(Class::DBI::SQLite);
  __PACKAGE__->set_db('Main', 'dbi:SQLite:dbname=dbfile', '', '');
  __PACKAGE__->set_up_table('Movies');

  package main;
  my $film = Film->create({
     name  => 'Bad Taste',
     title => 'Peter Jackson',
  });
  my $id = $film->id;		# auto-incremented

=head1 DESCRIPTION

Class::DBI::SQLite is an extension to Class::DBI for DBD::SQLite,
which allows you to populate auto incremented row id after insert.

C<set_up_table> method allows you to automate the setup of columns and
primary key by using of SQLite PRAGMA statement (with SQL::Statement
module)

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

C<set_up_table> implementation by Tomohiro Ikebe E<lt>ikebe@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::DBI>, L<DBD::SQLite> L<SQL::Statement>

=cut

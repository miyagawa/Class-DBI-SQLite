package Class::DBI::SQLite;

use strict;
use vars qw($VERSION);
$VERSION = 0.01;

require Class::DBI;
use base qw(Class::DBI);

sub _auto_increment_value {
    my $self = shift;
    return $self->db_Main->func("last_insert_rowid");
}

1;
__END__

=head1 NAME

Class::DBI::SQLite - Extension to Class::DBI for sqlite

=head1 SYNOPSIS

  package Film;
  use base qw(Class::DBI::SQLite);
  __PACKAGE__->set_db('Main', 'dbi:SQLite:dbname=dbfile', '', '');
  __PACKAGE__->table('Movies');
  __PACKAGE__->columns(Primary => qw(id));
  __PACKAGE__->columns(All => qw(id title director));

  package main;
  my $film = Film->create({
     name  => 'Bad Taste',
     title => 'Peter Jackson',
  });
  my $id = $film->id;		# auto-incremented

=head1 DESCRIPTION

Class::DBI::SQLite is an extension to Class::DBI for DBD::SQLite,
which allows you to populate auto incremented row id after insert.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Class::DBI>, L<DBD::SQLite>

=cut

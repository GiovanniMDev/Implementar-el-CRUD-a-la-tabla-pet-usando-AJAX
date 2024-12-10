#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use JSON;
use utf8;

# Encabezado para indicar que el contenido es JSON
print "Content-Type: application/json\n\n";

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=menagerie;host=localhost";
my $usuario = "root";
my $password = "123";

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $usuario, $password, { RaiseError => 1, AutoCommit => 1 })
    or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Establecer la codificación en UTF-8
$dbh->do("SET NAMES 'utf8'");

# Consulta SQL
my $sth = $dbh->prepare("SELECT name, owner, species, sex, birth, death FROM pet");
$sth->execute();

# Crear un array de registros
my @registros;
while (my $row = $sth->fetchrow_hashref) {
    push @registros, $row;
}

# Si no se encontraron registros, devolver un JSON vacío
if (@registros == 0) {
    my $json = encode_json({ registros => [] });
    print $json;
} else {
    # Devolver los datos como JSON si se encontraron registros
    my $json = encode_json({ registros => \@registros });
    print $json;
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;

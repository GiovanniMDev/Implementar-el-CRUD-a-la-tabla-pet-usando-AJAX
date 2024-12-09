#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use CGI;
use JSON; # Si no está instalado, ejecuta "cpan JSON"
use utf8;

my $cgi = CGI->new;

print $cgi->header('application/json;charset=UTF-8');

my $nombre = $cgi->param('nombre'); 
my $dueno = $cgi->param('dueno');
my $especie = $cgi->param('especie');   
my $genero = $cgi->param('genero');
my $fechaN = $cgi->param('fechaN');
my $fechaM = $cgi->param('fechaM'); 
if ($fechaM eq ""){
    $fechaM = undef;
}

my $op = JSON->new->utf8->pretty(1);
my $json = $op->encode({
    nombrePERL => $nombre,
    duenoPERL => $dueno,
    especiePERL => $especie,
    generoPERL => $genero,
    fechaNPERL => $fechaN,
    fechaMPERL => $fechaM,
});
print $json;

my $dsn = "DBI:mysql:database=menagerie;host=localhost";
my $usuario = "root";
my $password = "123";

# Conexión a la base de datos
my $dbh = DBI->connect($dsn, $usuario, $password, { RaiseError => 1, AutoCommit => 1 })
  or die "No se pudo conectar a la base de datos: $DBI::errstr";

# Asegurar que la conexión está en UTF-8
$dbh->do("SET NAMES 'utf8'");

# Crear la consulta SQL para insertar los datos
my $sql = "INSERT INTO pet (name, owner, species, sex, birth, death)
           VALUES (?, ?, ?, ?, ?, ?)";

# Preparar la consulta SQL
my $sth = $dbh->prepare($sql) or die "No se pudo preparar la consulta: $dbh->errstr";

# Ejecutar la consulta con los datos
$sth->execute($nombre, $dueno, $especie, $genero, $fechaN, $fechaM)
  or die "Error al insertar los datos: $dbh->errstr";

# Cerrar el statement handle y la conexión
$sth->finish();
$dbh->disconnect();
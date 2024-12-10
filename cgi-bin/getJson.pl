#!/usr/bin/perl -w
use strict;
use warnings;
use DBI;
use DBD::mysql;
use CGI qw(:standard);
use JSON; # Si no está instalado, ejecuta "cpan JSON"
use utf8;

# Capturar posibles errores en un eval para devolverlos al cliente
eval {
    my $dsn = "DBI:mysql:database=menagerie;host=localhost";
    my $usuario = "root";
    my $password = "123";

    # Conexión a la base de datos
    my $dbh = DBI->connect($dsn, $usuario, $password, { RaiseError => 1, AutoCommit => 1 })
      or die "No se pudo conectar a la base de datos: $DBI::errstr";

    # Asegurar que la conexión está en UTF-8
    $dbh->do("SET NAMES 'utf8'");

    # Capturar parámetros enviados por AJAX
    my $nombre  = param('nombre') || die "Falta el parámetro 'nombre'";
    my $dueno   = param('dueno') || die "Falta el parámetro 'dueno'";
    my $especie = param('especie') || die "Falta el parámetro 'especie'";
    my $genero  = param('genero') || die "Falta el parámetro 'genero'";
    my $fechaN  = param('fechaN') || die "Falta el parámetro 'fechaN'";
    my $fechaM  = param('fechaM'); # Puede ser opcional
    my $fechaM_valor = $fechaM eq '' ? undef : $fechaM;

    # Crear la consulta SQL para insertar los datos
    my $sql = "INSERT INTO pet (name, owner, species, sex, birth, death)
               VALUES (?, ?, ?, ?, ?, ?)";

    # Preparar la consulta SQL
    my $sth = $dbh->prepare($sql) or die "No se pudo preparar la consulta: $dbh->errstr";

    # Ejecutar la consulta con los datos
    $sth->execute($nombre, $dueno, $especie, $genero, $fechaN, $fechaM_valor)
      or die "Error al insertar los datos: $dbh->errstr";

    # Responder con un JSON de éxito
    print header('application/json');
    print encode_json({ success => 1, message => "Datos insertados correctamente." });
    
};

# Capturar y devolver errores en JSON si algo falla
if ($@) {
    print header('application/json', 'Status' => '500 Internal Server Error');
    print encode_json({ success => 0, error => $@ });
}


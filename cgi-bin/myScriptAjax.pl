#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use DBI;
use JSON;

# Configuración de la base de datos
my $db_host = "localhost";
my $db_user = "root";
my $db_pass = "password";
my $db_name = "mascotas";

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass, { RaiseError => 1, AutoCommit => 1 });

# Leer parámetros CGI
my $cgi = CGI->new;
my $nombre = $cgi->param('name') || '';
my $dueno  = $cgi->param('owner') || '';
my $especie = $cgi->param('species') || '';
my $genero = $cgi->param('sex') || '';
my $fechaN = $cgi->param('birth') || '';
my $fechaM = $cgi->param('death') || undef;

# Preparar codificador JSON
my $op = JSON->new->utf8->pretty(1);

if ($nombre && $dueno && $especie && $genero && $fechaN) {
    eval {
        my $sth = $dbh->prepare("INSERT INTO pet (name, owner, species, sex, birth, death) VALUES (?, ?, ?, ?, ?, ?)");
        $sth->execute($nombre, $dueno, $especie, $genero, $fechaN, $fechaM);
    };

    if ($@) {
        print "Content-type: application/json\n\n";
        print $op->encode({
            status => "error",
            message => "Error al insertar en la base de datos: $@"
        });
    } else {
        print "Content-type: application/json\n\n";
        print $op->encode({
            status => "success",
            message => "Registro insertado correctamente",
            nombrePERL => $nombre,
            duenoPERL => $dueno,
            especiePERL => $especie,
            generoPERL => $genero,
            fechaNPERL => $fechaN,
            fechaMPERL => $fechaM,
        });
    }
} else {
    print "Content-type: application/json\n\n";
    print $op->encode({
        status => "error",
        message => "Faltan parámetros obligatorios"
    });
}

$dbh->disconnect();
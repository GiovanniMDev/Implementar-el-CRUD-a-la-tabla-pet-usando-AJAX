#!/usr/bin/perl -w
use strict;
use warnings;
use CGI qw(:standard);
use JSON; # Si no está instalado, ejecuta "cpan JSON"
use utf8;

my $cgi = CGI->new;

print $cgi->header('application/json;charset=UTF-8');

# Capturar parámetros enviados por AJAX
my $nombre  = $cgi->param('nombre') || die "Falta el parámetro 'nombre'";
my $dueno   = $cgi->param('dueno') || die "Falta el parámetro 'dueno'";
my $especie = $cgi->param('especie') || die "Falta el parámetro 'especie'";
my $genero  = $cgi->param('genero') || die "Falta el parámetro 'genero'";
my $fechaN  = $cgi->param('fechaN') || die "Falta el parámetro 'fechaN'";
my $fechaM  = $cgi->param('fechaM'); # Puede ser opcional
my $fechaM_valor = $fechaM eq '' ? undef : $fechaM;

my $op = JSON -> new -> utf8 -> pretty(1);
my $json = $op -> encode({
    nombrePERL => $nombre,
    duenoPERL => $dueno,
    especiePERL => $especie,
    generoPERL => $genero,
    fechaNPERL => $fechaN,
    fechaMPERL => $fechaM_valor,
});
print $json;

# Capturar y devolver errores en JSON si algo falla
if ($@) {
    print header('application/json', 'Status' => '500 Internal Server Error');
    print encode_json({ success => 0, error => $@ });
}


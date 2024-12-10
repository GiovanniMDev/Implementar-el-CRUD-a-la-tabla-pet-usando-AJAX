#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use CGI;

# Crear objeto CGI
my $cgi = CGI->new;
print $cgi->header('text/html');

print <<EOF;
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Tabla de mascotas</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">
  <h2>Bienvenido a la base de mascotas! </h2>
  <form action="myScript.pl">
    <div class="form-group">
      <label for="nombre">Nombre:</label>
      <input type="text" class="form-control" id="nombre" placeholder="Ingresa el nombre la mascota" name="nombre" required>
    </div>
    <div class="form-group">
      <label for="dueno">Nombre del dueño:</label>
      <input type="text" class="form-control" id="dueno" placeholder="Ingresa dueño" name="dueno" required>
    </div>
	<div class="form-group">
      <label for="especie">Especie:</label>
      <input type="text" class="form-control" id="especie" placeholder="Ingresa especie" name="especie" required>
    </div>
	<div class="form-group">
      <label for="genero">Genero:</label>
      <select id="genero" name="genero" required>
	  		<option value="">Seleccionar Opción</option>
            <option value="M">Masculino</option>
            <option value="F">Femenino</option>
    	</select>
    </div>
	<div class="form-group">
      <label for="fechaN">Fecha de nacimiento:</label>
      <input type="date" class="form-control" id="fechaN" name="fechaN" required>
    </div>
	<div class="form-group">
      <label for="fechaM">Fecha de deseso: (Opcional)</label>
      <input type="date" class="form-control" id="fechaM" name="fechaM">
    </div>
    <div class="form-group">
      <div id="respAjax" class=""></div>
    </div>	
    
    <button id="submitAJAX"   class="btn_submit btn btn-default">Submit with AJAX</button>
  </form>
  <div id="tabla-container">
    <!-- La tabla se insertará aquí con los datos -->
  </div>
</div>
<script>

\$(document).ready(function() {
  // Realizar una solicitud AJAX al script getDB.pl para obtener los datos de la base de datos
  \$.ajax({
    url: 'getDB.pl',  // URL del script Perl que recupera los datos de la base de datos
    method: 'GET',
    dataType: 'json',
    success: function(response) {
      console.log(response);
      if (response.registros.length > 0) {
        // Crear la tabla HTML con los datos
        let tabla = "<table class='table table-bordered'>" +
                        "<tr>" +
                            "<th>Nombre</th>" +
                            "<th>Dueño</th>" +
                            "<th>Especie</th>" +
                            "<th>Género</th>" +
                            "<th>Fecha de Nacimiento</th>" +
                            "<th>Fecha de Deceso</th>" +
                        "</tr>";
        
        // Iterar sobre los registros y llenar la tabla
        \$.each(response.registros, function(index, registros) {
          tabla += "<tr>" +
                       "<td>" + registros.name + "</td>" +
                       "<td>" + registros.owner + "</td>" +
                       "<td>" + registros.species + "</td>" +
                       "<td>" + registros.sex + "</td>" +
                       "<td>" + registros.birth + "</td>" +
                       "<td>" + (registros.death ? registros.death : 'No disponible') + "</td>" +
                   "</tr>";
        });

        tabla += "</table>";
        \$('#tabla-container').html(tabla);  // Insertar la tabla generada en el contenedor
      } else {
        \$('#tabla-container').html('<p>No hay datos disponibles.</p>');
      }
    },
    error: function(e) {
        console.log(e);
        \$('#tabla-container').html('<p>Error al cargar los datos.</p>');
    }
  });

	\$('.btn_submit').on( 'click', function(e) {
	
      var objectEvent=\$(this);

		  e.preventDefault();
	   	if(objectEvent.attr('id')==='submitAJAX'){

        console.log("ajax");

        var dt={ 
          nombre: \$("#nombre").val(),
          dueno: \$("#dueno").val(),
          especie: \$("#especie").val(),
          genero: \$("#genero").val(),
          fechaN: \$("#fechaN").val(),
          fechaM: \$("#fechaM").val() || null
        };

        if (!dt.nombre || !dt.dueno || !dt.especie || !dt.genero || !dt.fechaN) {
            alert("Por favor, completa todos los campos obligatorios.");
            return false;
        }
        
        console.log(dt.nombre);

        var request =\$.ajax({
                                  url: "myScriptAjax.pl",
                                  type: "POST",
                                  data: dt,
                                  dataType: "json"
        });

        var connectSQL =\$.ajax({
                                  url: "getJson.pl",
                                  type: "POST",
                                  data: dt,
                                  dataType: "json"
        });

        request.done(function(dataset){
          console.log("success");
          console.log(dataset);
          console.log(dataset.nombrePERL);
          console.log(dataset.duenoPERL);
          console.log(dataset.especiePERL);
          console.log(dataset.fechaNPERL);			
          \$('#respAjax').addClass("well");
          \$('#respAjax').html(
              "<table border='1'>" +
              "  <tr><th>Nombre</th><th>Dueño</th><th>Especie</th>"+ 
              "<th>Género</th><th>Fecha de Nacimiento</th><th>Fecha de Deseso</th></tr>" +
              "  <tr><td>" + dataset.nombrePERL + "</td>" +
              "  <td>" + dataset.duenoPERL + "</td>" +
              "  <td>" + dataset.especiePERL + "</td>" +
              "  <td>" + dataset.generoPERL + "</td>" +
              "  <td>" + dataset.fechaNPERL + "</td>" +
              "  <td>" + dataset.fechaMPERL + "</td>" +
              "  <td>ACTUALIZAR</td>" +
              "  <td>BORRAR</td>" +
              "  <td>" +
              "  <button onclick='eliminarRegistro)' style='background:none;border:none;cursor:pointer;'>" +
              "  </button> " +
              "  <button onclick='actualizarRegistro' style='background:none;border:none;cursor:pointer;'>" +
              "  </button>" +
              "  </td>" +
              "</tr>" +
              "</table>"
          );
        }); 
        
        request.fail(function(jqXHR, textStatus, errorThrown) {
          alert("Request failed: " + textStatus);
          console.log("Error details:");
          console.log("Status: " + jqXHR.status);
          console.log("Response text: " + jqXHR.responseText);
          console.log("Error thrown: " + errorThrown);
        });
      }
           //return true;            
	}); 

})

</script>
</body>
</html>
EOF

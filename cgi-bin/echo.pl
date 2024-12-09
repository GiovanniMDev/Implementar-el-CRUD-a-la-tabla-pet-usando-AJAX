#!/usr/bin/perl


use strict;
use warnings;

print <<EOF;
Content-type: text/html

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

    <button id="submitNoAJAX"   class="btn_submit btn btn-default">Submit with AJAX</button>
    <button id="submitAJAX"   class="btn_submit btn btn-default">Submit with AJAX</button>
  </form>
</div>
<script>

\$(document).ready(function() {
  

	\$('.btn_submit').on( 'click', function(e) {
	
      var objectEvent=\$(this);

      if(objectEvent.attr('id')==='submitNoAJAX'){ 
			  console.log("submitNoAJAX");                           
        \$('form').attr('action','myScript.pl'); 
			  return true;     
      }

		  e.preventDefault();
	   	if(objectEvent.attr('id')==='submitAJAX'){

        console.log("ajax");

        var dt={ 
          nombre: \$("#nombre").val(),
          dueno: \$("#dueno").val(),
          especie: \$("#especie").val(),
          genero: \$("#genero").val(),
          fechaN: \$("#fechaN").val(),
          fechaM: \$("#fechaM").val()
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

        request.done(function(dataset){
          console.log("success");
          console.log(dataset);
          console.log(dataset.nombrePERL);
          console.log(dataset.duenoPERL);
          console.log(dataset.especiePERL);
          console.log(dataset.fechaNPERL);			
          \$('#respAjax').addClass("well");
          \$('#respAjax').html("nombre="+dataset.nombrePERL+", dueño="+dataset.duenoPERL+
          ", especie="+dataset.especiePERL+", genero="+dataset.generoPERL+
          ", fechaN="+dataset.fechaNPERL+", fechaM="+dataset.fechaMPERL);
        }); 
        
        request.fail(function(jqXHR, textStatus) {
          alert("Request failed: " + textStatus);
          console.log("jqXHR:", jqXHR);
          console.log("jqXHR.responseText:", jqXHR.responseText);
          console.log("jqXHR.status:", jqXHR.status);
        });
	   	}
           //return true;            
	}); 

})

</script>
</body>
</html>
EOF

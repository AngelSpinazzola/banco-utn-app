<%@ page import="java.util.ArrayList"%>
<%@ page import="entidad.Provincia"%>
<%@ page import="entidad.Localidad"%>
<%@ page import="entidad.Nacionalidad"%>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Agregar cliente</title>
<%@ include file="Componentes/Head.jsp"%>
<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    padding: 0;
    background-color: #f4f6f9;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.form-title {
    text-align: left;
    color: #333;
    margin-bottom: 30px;
    padding-left: 130px;
    padding-top: 20px;
}

.form-container {
    background-color: white;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    padding: 30px;
    max-width: 900px;
    margin: 0 auto;
}

.row {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}

.col-md-6, .col-md-4 {
    flex: 1;
    min-width: 250px;
}

.col-md-6.email-col {
    min-width: 350px;
}

.col-md-4.address-col {
    min-width: 200px;
}

.form-label {
    font-weight: 500;
    color: #555;
    margin-bottom: 5px;
}

.form-control, .form-select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 6px;
    transition: border-color 0.3s ease;
}

.form-control:focus, .form-select:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
}

.form-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
    padding-top: 30px;
    max-width: 900px;
    margin-left: auto;
    margin-right: auto;
}

.btn-volver{
    padding: 10px 20px;
    border-radius: 6px;
    width: 150px;
    transition: all 0.3s ease;
}

.btn-secondary {
    background-color: #6c757d;
    color: white;
    border: none;
}

.btn-nuevo-cliente {
    background-color: #007bff;
    width: 500px;
    color: white;
    border: none;
}

.btn:hover {
    opacity: 0.9;
}

#passwordError {
    color: #dc3545;
    font-size: 0.9em;
}

@media (max-width: 768px) {
    .col-md-6, .col-md-4 {
        flex-basis: 100%;
    }
    
    .form-actions {
        flex-direction: column;
        gap: 10px;
    }
    
    .form-actions .btn {
        width: 100%;
    }
}
</style>
</head>

<body>
	<!-- Menú de Navegación -->
	<%@ include file="Componentes/NavbarAdmin.jsp"%>

	<div class="container">
		<h3 class="form-title">Agregar nuevo cliente</h3>
			<div class="form-container">
				<form id="form-alta" action="AltaClienteSv" method="post">
			    <%
			        Map<String, String> formData = (Map<String, String>) session.getAttribute("formData");
			    %>
			    <div class="row">
			        <!-- Nombre -->
			        <div class="col-md-6">
			            <label for="nombre" class="form-label">Nombre</label>
			            <input type="text" id="nombre" name="nombre" class="form-control"
			                placeholder="Ingrese el nombre" required pattern="^[a-zA-ZÀ-ÿ\s]+$"
			                value="<%= formData != null ? formData.get("nombre") : "" %>"
			                title="El nombre solo debe contener letras." maxlength="49"
			                oninput="validarLongitud(this, 49)">
			        </div>
			
			        <!-- Apellido -->
			        <div class="col-md-6">
			            <label for="apellido" class="form-label">Apellido</label>
			            <input type="text" id="apellido" name="apellido" class="form-control"
			                placeholder="Ingrese el apellido" required pattern="^[a-zA-ZÀ-ÿ\s]+$"
			                value="<%= formData != null ? formData.get("apellido") : "" %>"
			                title="El apellido solo debe contener letras." maxlength="49"
			                oninput="validarLongitud(this, 49)">
			        </div>
			
			        <!-- DNI -->
			        <div class="col-md-6">
			            <label for="dni" class="form-label">DNI</label>
			            <input type="text" id="dni" name="dni" class="form-control"
			                placeholder="Ingrese el DNI" required pattern="^\d{8,9}$"
			                value="<%= formData != null ? formData.get("dni") : "" %>"
			                title="El DNI debe ser numérico y debe contener 8 o 9 dígitos." maxlength="12">
			        </div>
			
			        <!-- CUIL -->
			        <div class="col-md-6">
			            <label for="cuil" class="form-label">Cuil</label>
			            <input type="text" id="cuil" name="cuil" class="form-control"
			                placeholder="Ingrese el CUIL" required pattern="^\d{2}-\d{7,9}-\d{1}$"
			                value="<%= formData != null ? formData.get("cuil") : "" %>"
			                title="El CUIL debe tener el formato XX-XXXXXXXX-X o XX-XXXXXXXXX-X, incluyendo los guiones." maxlength="14">
			        </div>
			
			        <!-- Email -->
			        <div class="col-md-6 email-col">
			            <label for="email" class="form-label">Email</label>
			            <input type="email" id="email" name="email" class="form-control"
			                required placeholder="Ingrese el email" maxlength="44"
			                value="<%= formData != null ? formData.get("email") : "" %>"
			                title="El email no debe superar los 44 caracteres.">
			        </div>
			
			        <!-- Nombre de usuario -->
			        <div class="col-md-6">
			            <label for="nombreUsuario" class="form-label">Nombre de usuario</label>
			            <input type="text" id="nombreUsuario" name="nombreUsuario"
			                class="form-control" required placeholder="Nombre de usuario"
			                maxlength="24" value="<%= formData != null ? formData.get("nombreUsuario") : "" %>">
			        </div>
			
			        <!-- Contraseña -->
			        <div class="col-md-6">
			            <label for="password" class="form-label">Contraseña</label>
			            <input type="password" id="password" name="password" class="form-control" required placeholder="Contraseña" maxlength="24">
			        </div>
			
			        <!-- Confirmar contraseña -->
			        <div class="col-md-6">
			            <label for="confirmPassword" class="form-label">Confirmar contraseña</label>
			            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required placeholder="Confirmar contraseña" 
			            maxlength="24">
			            <div id="passwordError" class="text-danger mt-1" style="display: none;">
			                Las contraseñas no coinciden.
			            </div>
			        </div>
			
			        <!-- Sexo -->
			        <div class="col-md-6">
			            <label for="sexo" class="form-label">Sexo</label>
			            <select id="sexo" name="sexo" class="form-select" required>
			                <option value="">Seleccione el sexo</option>
			                <option value="Masculino" <%= formData != null && "Masculino".equals(formData.get("sexo")) ? "selected" : "" %>>Masculino</option>
			                <option value="Femenino" <%= formData != null && "Femenino".equals(formData.get("sexo")) ? "selected" : "" %>>Femenino</option>
			                <option value="No definido" <%= formData != null && "No definido".equals(formData.get("sexo")) ? "selected" : "" %>>Otro</option>
			            </select>
			        </div>
			
			        <!-- Teléfono -->
			        <div class="col-md-6">
			            <label for="telefono" class="form-label">Teléfono</label>
			            <input type="text" id="telefono" name="telefono" class="form-control" placeholder="Ingrese el teléfono del cliente"
			            required pattern="^[+]?[\d ]+$" title="El telefono solo debe contener numeros, espacios y el signo '+'." maxlength="29" 
			            value="<%= formData != null ? formData.get("telefono") : "" %>">
			        </div>
			
			        <!-- Fecha de Nacimiento -->
			        <div class="col-md-6">
			            <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
			            <input type="date" id="fechaNacimiento" name="fechaNacimiento"
			                class="form-control" required
			                value="<%= formData != null ? formData.get("fechaNacimiento") : "" %>">
			        </div>
			        
			        <!-- Nacionalidad -->
			        <div class="col-md-6">
			            <label for="nacionalidad" class="form-label">Nacionalidad</label>
			            <select name="nacionalidad" class="form-select" id="nacionalidad" required>
			                <option value="">Seleccione la nacionalidad</option>
			                <%
			                    ArrayList<Nacionalidad> listaNacionalidades = (ArrayList<Nacionalidad>) request.getAttribute("listaNacionalidades");
			                    String nacionalidadSeleccionada = formData != null ? formData.get("nacionalidad") : null;
			                    
			                    for (Nacionalidad nacionalidad : listaNacionalidades) {
			                        boolean isSelected = nacionalidadSeleccionada != null && nacionalidadSeleccionada.equals(String.valueOf(nacionalidad.getId()));
			                %>
			                <option value="<%=nacionalidad.getId()%>" <%= isSelected ? "selected" : "" %>>
			                    <%=nacionalidad.getNacionalidad()%>
			                </option>
			                <%
			                    }
			                %>
			            </select>
			        </div>
			
			        <!-- Provincia -->
			        <div class="col-md-6">
			            <label for="provincia" class="form-label">Provincia</label>
			            <select id="provincia" name="provincia" class="form-select" required>
			                <option value="">Seleccione la provincia</option>
			                <%
			                    ArrayList<Provincia> listaProvincias = (ArrayList<Provincia>) request.getAttribute("listaProvincias");
			                    String provinciaSeleccionada = formData != null ? formData.get("provincia") : null;
			                    
			                    for (Provincia provincia : listaProvincias) {
			                        boolean isSelected = provinciaSeleccionada != null && provinciaSeleccionada.equals(String.valueOf(provincia.getId()));
			                %>
			                <option value="<%=provincia.getId()%>" <%= isSelected ? "selected" : "" %>>
			                    <%=provincia.getNombre()%>
			                </option>
			                <%
			                    }
			                %>
			            </select>
			        </div>
			
			        <!-- Localidad -->
			        <div class="col-md-6">
			            <label for="localidad" class="form-label">Localidad</label>
			            <select id="localidad" name="localidad" class="form-select" required>
			                <option value="">Seleccione la localidad</option>
			                <%
			                    ArrayList<Localidad> listaLocalidades = (ArrayList<Localidad>) request.getAttribute("listaLocalidades");
			                    String localidadSeleccionada = formData != null ? formData.get("localidad") : null;
			                    
			                    for (Localidad localidad : listaLocalidades) {
			                        boolean isSelected = localidadSeleccionada != null && localidadSeleccionada.equals(String.valueOf(localidad.getId()));
			                %>
			                <option value="<%=localidad.getId()%>" <%= isSelected ? "selected" : "" %>>
			                    <%=localidad.getNombre()%>
			                </option>
			                <%
			                    }
			                %>
			            </select>
			        </div>
			
			        <!-- Código Postal -->
			        <div class="col-md-4">
			            <label for="codigoPostal" class="form-label">Código Postal</label>
			            <input type="text" id="codigoPostal" name="codigoPostal"
			                class="form-control" required placeholder="Código Postal"
			                pattern="^[A-Za-z0-9]{1,14}$"
			                value="<%= formData != null ? formData.get("codigoPostal") : "" %>"
			                title="El código postal puede contener hasta 14 caracteres alfanuméricos"
			                maxlength="14">
			        </div>
			
			        <!-- Calle -->
			        <div class="col-md-4 address-col">
			            <label for="calle" class="form-label">Calle</label>
			            <input type="text" id="calle" name="calle" class="form-control"
			                required placeholder="Calle" pattern="^[a-zA-Z\s]+$"
			                value="<%= formData != null ? formData.get("calle") : "" %>"
			                title="La calle solo debe contener letras." maxlength="29">
			        </div>
			
			        <!-- Número -->
			        <div class="col-md-4 address-col">
			            <label for="numero" class="form-label">Número</label>
			            <input type="text" id="numero" name="numero" class="form-control"
			                required placeholder="Número" pattern="^\d+$"
			                value="<%= formData != null ? formData.get("numero") : "" %>"
			                title="El número solo debe contener números." maxlength="29">
			        </div>
			    </div>
			</form>
			
			</div>
	        <div class="form-actions">
	            <button type="button" class="btn btn-secondary btn-volver" onclick="window.location.href='ListarClientesSv'">Volver</button>
	            <button type="submit" form="form-alta" class="btn btn-nuevo-cliente">Dar alta</button>
	        </div>
		</div>
</body>
<script>
	window.onload = function() {
	    <% 
	    Boolean errorExisteDni = (Boolean) session.getAttribute("errorExisteDni");
	    Boolean errorExisteCuil = (Boolean) session.getAttribute("errorExisteCuil");
	    Boolean errorExisteUsuario = (Boolean) session.getAttribute("errorExisteUsuario");
	    Boolean errorExisteEmail = (Boolean) session.getAttribute("errorExisteEmail");
	    
	    if (errorExisteCuil != null && errorExisteCuil) {
	    %>
	        Swal.fire({
	            icon: 'error',
	            title: 'Error',
	            text: 'El CUIL ingresado ya está registrado.'
	        });
	    <%
	    } else if (errorExisteDni != null && errorExisteDni) { 
	    %>
	        Swal.fire({
	            icon: 'error',
	            title: 'Error',
	            text: 'El DNI ingresado ya está registrado.'
	        });
	    <% 
	    }
	    else if (errorExisteUsuario != null && errorExisteUsuario) { 
	    %>
	        Swal.fire({
	            icon: 'error',
	            title: 'Error',
	            text: 'Ya existe un cliente con el nombre de usuario y contraseña.'
	        });
	    <% 
	    }
	    else if (errorExisteEmail != null && errorExisteEmail) { 
		    %>
		        Swal.fire({
		            icon: 'error',
		            title: 'Error',
		            text: 'Ya existe un cliente con ese email.'
		        });
		    <% 
		    }
	    session.removeAttribute("errorExisteDni");
	    session.removeAttribute("errorExisteCuil");
	    session.removeAttribute("errorExisteUsuario");
	    session.removeAttribute("errorExisteEmail");
	    %>
	};
</script>

<script>
    function validarLongitud(input, maxLength) {
        if (input.value.length > maxLength) {
            input.value = input.value.substring(0, maxLength);
        }
    }
    
    document.getElementById("form-alta").addEventListener("submit", function (e) {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            e.preventDefault(); 
            document.getElementById("passwordError").style.display = "block"; 
        } else {
            document.getElementById("passwordError").style.display = "none"; 
        }
    });
</script>
</html>
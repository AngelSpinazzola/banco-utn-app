<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="entidad.Cliente"%>
<%@ page import="entidad.Nacionalidad"%>
<%@ page import="entidad.Provincia"%>
<%@ page import="entidad.Localidad"%>
<%@ page import="entidad.Usuario"%>
<%@ page import="entidad.Direccion"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html lang="es">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Banco UTN</title>

<%@ include file="Componentes/Head.jsp"%>
</head>
<body>
	<jsp:include page="Componentes/NavbarAdmin.jsp"></jsp:include>

	<!-- Contenedor del Formulario de Editar Cliente -->
	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-md-8 col-lg-6">
				<div class="card shadow-lg p-4">
					<h2 class="text-center mb-4">Editar Cliente</h2>
					<form action="EditarClienteSv" method="post" class="row g-3">
						<% Cliente cliente = (Cliente) request.getAttribute("cliente"); %>
						<input id="idCliente" name="idCliente" value="<%= cliente.getIdCliente() %>" type="hidden">
						
						<!-- Nombre -->
						<div class="col-md-6">
						
							<label for="nombre" class="form-label">Nombre</label> 
							<input type="text" required id="nombre" name="nombre" class="form-control" value="<%= cliente.getNombre() %>">
						</div>
						
						<!-- Apellido -->
						<div class="col-md-6">
							<label for="apellido" class="form-label">Apellido</label> 
							<input type="text" required id="apellido" name="apellido" class="form-control" value="<%= cliente.getApellido() %>">
						</div>
						
						<!-- Dni -->
						<div class="col-md-6">
							<label for="dni" class="form-label">Dni</label> 
							<input type="text" required id="dni" name="dni" class="form-control" value="<%= cliente.getDni() %>">
						</div>
						
						<!-- Cuil -->
						<div class="col-md-6">
							<label for="cuil" class="form-label">Cuil</label> 
							<input type="text" required id="cuil" name="cuil" class="form-control" value="<%= cliente.getCuil() %>">
						</div>
						
						<!-- Sexo -->
						<div class="col-md-6">
							<label for="sexo" class="form-label">Sexo</label>
						    <select id="sexo" name="sexo" class="form-control">
						        <option value="Masculino" <%= cliente.getSexo() == "Masculino" ? "selected" : "" %>>Masculino</option>
						        <option value="Femenino" <%= cliente.getSexo() == "Femenino" ? "selected" : "" %>>Femenino</option>
						    </select>
						</div>
						
						<!-- Email -->
						<div class="col-md-6">
							<label for="email" class="form-label">Teléfono</label> 
							<input type="text" required id="email" name="email" class="form-control" value="<%= cliente.getEmail() %>">
						</div>
						
						<!-- Telefono -->
						<div class="col-md-6">
							<label for="telefono" class="form-label">Teléfono</label> 
							<input type="text" required id="telefono" name="telefono" class="form-control" value="<%= cliente.getNumeroTelefono() %>">
						</div>
						
						<!-- Fecha de nacimiento -->
						<div class="col-md-6">
						    <label for="fechaNacimiento" class="form-label">Fecha de Nacimiento</label>
						    <input type="date" required id="fechaNacimiento" name="fechaNacimiento" class="form-control" value="<%= cliente.getFechaNacimiento() %>" readonly>
						</div>
															
						<!-- Nacionalidad -->
						<div class="col-md-6">
							<label for="nacionalidad" class="form-label">Nacionalidad</label>
							<select id="nacionalidad" name="nacionalidad" class="form-select">
							    <% for (Nacionalidad nacionalidad : (List<Nacionalidad>) request.getAttribute("listaNacionalidades")) { %>
							        <option value="<%= nacionalidad.getId() %>" <%= nacionalidad.getId() == cliente.getNacionalidad().getId() ? "selected" :"" %>>
							            <%= nacionalidad.getNacionalidad() %>
							        </option>
							    <% } %>
							</select>
						</div>
																				
						<!-- Provincia -->
						<div class="col-md-6">
							<label for="provincia" class="form-label">Provincia</label>
							<select id="provincia" name="provincia" class="form-select">
							    <% for (Provincia provincia : (List<Provincia>) request.getAttribute("listaProvincias")) { %>
							        <option value="<%= provincia.getId() %>" <%= provincia.getId() == cliente.getDireccion().getProvincia().getId() ? "selected" :"" %>>
							            <%= provincia.getNombre() %>
						        	</option>
							    <% } %>
							</select>
						</div>
																				
						<!-- Localidad -->
						<div class="col-md-6">
							<label for="localidad" class="form-label">Localidad</label>
							<select id="localidad" name="localidad" class="form-select">
							    <% for (Localidad localidad : (List<Localidad>) request.getAttribute("listaLocalidades")) { %>
							        <option value="<%= localidad.getId() %>" <%= localidad.getId() == cliente.getDireccion().getLocalidad().getId() ? "selected" :"" %>>
							            <%= localidad.getNombre() %>
							        </option>
							    <% } %>
							</select>
						</div>

						<!-- Codigo postal -->
						<div class="col-md-6">
							<label for="codigoPostal" class="form-label">Código postal</label> 
							<input type="text" required id="codigoPostal" name="codigoPostal" class="form-control" value="<%= cliente.getDireccion().getCodigoPostal() %>">
						</div>
						
						<!-- Calle -->
						<div class="col-md-6">
							<label for="calle" class="form-label">Calle</label> 
							<input type="text" required id="calle" name="calle" class="form-control" value="<%= cliente.getDireccion().getCalle() %>">
						</div>
						
						<!-- Numero -->
						<div class="col-md-6">
							<label for="numero" class="form-label">altura</label> 
							<input type="text" required id="numero" name="numero" class="form-control" value="<%= cliente.getDireccion().getNumero() %>">
						</div>

						<!-- Botón para Guardar Cambios -->
						<div class="col-12 d-flex justify-content-center">
							<input type="submit" class="btn btn-primary me-2" value="Guardar cambios"> 
							<input type="button" class="btn btn-secondary" onclick="window.location.href='ListarClientesSv'" value="Cancelar">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	 <script>
    document.addEventListener("DOMContentLoaded", function () {
        // Mostrar el Toast si hay un mensaje de error del backend
        const toastElement = document.getElementById("validationToast");
        const toastBody = toastElement.querySelector(".toast-body").textContent.trim();
        if (toastBody) {
            const toast = new bootstrap.Toast(toastElement);
            toast.show();
        }
    });
    </script>

</body>
</html>
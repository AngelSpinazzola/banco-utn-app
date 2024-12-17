<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="entidad.Cliente"%>
<%@ page import="entidad.Nacionalidad"%>
<%@ page import="entidad.Provincia"%>
<%@ page import="entidad.Localidad"%>
<%@ page import="entidad.Usuario"%>
<%@ page import="entidad.Direccion"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Banco UTN</title>

<%@ include file="Componentes/Head.jsp"%>
<style>
	.form-title {
	    text-align: center;
	    color: #333;
	    padding-right: 490px;
	}
	.form-actions {
	    display: flex;
	    justify-content: space-between;
	    margin-top: 20px;
	    padding-top: 20px;
	    max-width: 900px;
	    margin-left: auto;
	    margin-right: auto;
	}
	
	.btn-nuevo-cliente {
	    background-color: #007bff;
	    width: 300px;
	    color: white;
	    border: none;
	    padding: 10px 20px;
	}	
	
	.btn-volver{
	    padding: 10px 20px;
	    border-radius: 6px;
	    width: 100px;
	    transition: all 0.3s ease;
	}
	input[readonly] {
	    background-color: #f9f9f9; 
	    color: #6c757d; 
	    border: 1px solid #ced4da; 
	    cursor: not-allowed; 
	    opacity: 1; 
	    pointer-events: none; 
	}
	
</style>
</head>
<body>
	<jsp:include page="Componentes/NavbarAdmin.jsp"></jsp:include>

	<!-- Contenedor del Formulario de Editar Cliente -->
	<div class="container mt-5">
		<div class="row justify-content-center">
			<h3 class="form-title">Editar cliente</h3>
			<div class="col-md-8 col-lg-6">
				<div class="card shadow-lg p-4">
					<form id="form-editar" action="EditarClienteSv" method="post" class="row g-3">
						<% Cliente cliente = (Cliente) request.getAttribute("cliente"); %>
						<input id="idCliente" name="idCliente" value="<%= cliente.getIdCliente() %>" type="hidden">
						
						<!-- Nombre -->
						<div class="col-md-6">
							<label for="nombre" class="form-label">Nombre</label> 
							<input type="text" required id="nombre" name="nombre" class="form-control" value="<%= cliente.getNombre() %>" 
							title="El nombre solo puede contener letras y espacios." 
							maxlength="49"
							required pattern="^[a-zA-ZÀ-ÿ]+(?: [a-zA-ZÀ-ÿ]+)*$">
						</div>
						
						<!-- Apellido -->
						<div class="col-md-6">
							<label for="apellido" class="form-label">Apellido</label> 
							<input type="text" required id="apellido" name="apellido" class="form-control" value="<%= cliente.getApellido() %>"
							title="El apellido solo puede contener letras y espacios." 
							maxlength="49"
							required pattern="^[a-zA-ZÀ-ÿ]+(?: [a-zA-ZÀ-ÿ]+)*$">
						</div>
						
						<!-- Dni -->
						<div class="col-md-6">
							<label for="dni" class="form-label">Dni</label> 
							<input type="text" readonly="readonly" required id="dni" name="dni" class="form-control" value="<%= cliente.getDni() %>">
						</div>
						
						<!-- Cuil -->
						<div class="col-md-6">
							<label for="cuil" class="form-label">Cuil</label> 
							<input type="text" readonly="readonly" required id="cuil" name="cuil" class="form-control" value="<%= cliente.getCuil() %>">
						</div>
						
						<!-- Sexo -->
						<div class="col-md-6">
							<label for="sexo" class="form-label">Sexo</label>
						    <select id="sexo" name="sexo" class="form-select">
						        <option value="Masculino" <%= cliente.getSexo() == "Masculino" ? "selected" : "" %>>Masculino</option>
						        <option value="Femenino" <%= cliente.getSexo() == "Femenino" ? "selected" : "" %>>Femenino</option>
						        <option value="Otro" <%= cliente.getSexo() == "No definido" ? "selected" : "" %>>Otro</option>
						    </select>
						</div>
						
						<!-- Email -->
						<div class="col-md-6">
							<label for="email" class="form-label">Email</label> 
							<input type="email" id="email" name="email" required placeholder="Ingrese el email" maxlength="44"
							title="El email no debe superar los 44 caracteres." class="form-control" value="<%= cliente.getEmail() %>">
						</div>
						
						<!-- Telefono -->
						<div class="col-md-6">
							<label for="telefono" class="form-label">Teléfono</label> 
							<input type="text" 
							id="telefono" 
							name="telefono" 
							class="form-control"
							placeholder="Ingrese el teléfono" 
							value="<%= cliente.getNumeroTelefono() %>"
							required 
							pattern="^\+?\d+(\s\d+)*$"
							title="Ingrese un número de teléfono válido. Puede incluir el signo '+' al inicio y espacios entre números." 
							maxlength="29">
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
							<input type="text" 
							required id="codigoPostal" 
							pattern="^[A-Za-z0-9]{1,14}$"
							name="codigoPostal" 
							class="form-control" 
							title="El código postal puede contener hasta 14 caracteres alfanuméricos"
							maxlength="14"
							value="<%= cliente.getDireccion().getCodigoPostal() %>">
						</div>
						
						<!-- Calle -->
						<div class="col-md-6">
							<label for="calle" class="form-label">Calle</label> 
							<input type="text" 
							required id="calle" 
							name="calle" 
							pattern="^[a-zA-Z0-9]+( [a-zA-Z0-9]+)*$" 
							class="form-control" 
							maxlength="29"
							title="La calle solo debe contener letras." 
							value="<%= cliente.getDireccion().getCalle() %>">
						</div>
						
						<!-- Numero -->
						<div class="col-md-6">
							<label for="numero" class="form-label">Altura</label> 
							<input type="text" 
							required id="numero" 
							name="numero" 
							class="form-control" 
							pattern="^\d+$"
							title="La altura solo debe contener números." 
							maxlength="29"
							value="<%= cliente.getDireccion().getNumero() %>">
						</div>

					</form>
				</div>
				<!-- Botón para Guardar Cambios -->
				<div class="form-actions">
					<button type="button" class="btn btn-secondary btn-volver" onclick="window.location.href='ListarClientesSv'">Cancelar</button>
					<button type="submit" form="form-editar" class="btn btn-nuevo-cliente">Guardar cambios</button>
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
<%@ page import="java.util.ArrayList"%>
<%@ page import="entidad.Provincia"%>
<%@ page import="entidad.Localidad"%>
<%@ page import="entidad.Nacionalidad"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
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

.container {
	height: calc(100vh - 78px);
	position: relative;
	overflow-y: hidden;
}

body {
	margin: 0;
	padding: 0;
	min-height: 100vh;
	position: relative;
	overflow-x: hidden;
}

.form-container {
	max-width: 800px;
	width: 100%;
	margin-top: -190px;
	padding: 2rem;
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.form-title {
	margin-top: 30px;
	padding-left: 200px;
	display: flex;
	position: relative;
	z-index: 1;
}

.d-flex {
	min-height: calc(100vh - 100px);
	height: auto;
	padding: 2rem 0;
}

.button-group {
	display: flex;
	justify-content: space-between;
	margin-top: 2rem;
}

.btn-general {
	width: 48%;
}

.row {
	margin-right: 0;
	margin-left: 0;
}

.p-4 {
	padding: 1.5rem !important;
}

.g-3 { -
	-bs-gutter-y: 1rem;
}

.form-control, .form-select {
	max-width: 100%;
}
</style>
</head>

<body>
	<!-- Men� de Navegaci�n -->
	<%@ include file="Componentes/NavbarAdmin.jsp"%>

	<div class="container">
		<!-- Contenedor principal del formulario -->
		<h3 class="form-title">Agregar nuevo cliente</h3>
		<div class="d-flex justify-content-center align-items-center vh-100">
			<div class="p-4 border rounded shadow-lg bg-white form-container">
				<form action="AltaClienteSv" method="post">
					<div class="row g-3">
						<!-- Nombre y Apellido -->
						<div class="col-md-6">
							<label for="nombre" class="form-label">Nombre</label> <input
								type="text" id="nombre" name="nombre" class="form-control"
								required placeholder="Ingrese el nombre del cliente">
						</div>
						<div class="col-md-6">
							<label for="apellido" class="form-label">Apellido</label> <input
								type="text" id="apellido" name="apellido" class="form-control"
								required placeholder="Ingrese el apellido del cliente">
						</div>

						<!-- DNI y CUIL -->
						<div class="col-md-6">
							<label for="dni" class="form-label">DNI</label> <input
								type="text" id="dni" name="dni" class="form-control" required
								placeholder="Ingrese el DNI" pattern="^\d{7,8}$"
								title="El DNI debe ser num�rico y debe contener entre 7 y 8 d�gitos.">
						</div>


						<div class="col-md-6">
							<label for="cuil" class="form-label">Cuil</label> <input
								type="text" id="cuil" name="cuil" class="form-control" required
								placeholder="Ingrese el cuil">
						</div>

						<!-- Email y Contrase�a -->
						<div class="col-md-6">
							<label for="email" class="form-label">Email</label> <input
								type="email" id="email" name="email" class="form-control"
								required placeholder="Ingrese el email">
						</div>

						<!-- Contrase�a -->
						<div class="col-md-6">
							<label for="password" class="form-label">Contrase�a</label> <input
								type="password" id="password" name="password"
								class="form-control" required placeholder="Contrase�a">
						</div>

						<!-- Confirmar contrase�a -->
						<div class="col-md-6">
							<label for="confirmPassword" class="form-label">Confirmar
								contrase�a</label> <input type="password" id="confirmPassword"
								name="confirmPassword" class="form-control" required
								placeholder="Confirmar contrase�a">
						</div>

						<!-- Nombre de usuario y Sexo -->
						<div class="col-md-6">
							<label for="nombreUsuario" class="form-label">Nombre de
								usuario</label> <input type="text" id="nombreUsuario"
								name="nombreUsuario" class="form-control" required
								placeholder="Nombre de usuario">
						</div>
						<div class="col-md-6">
							<label for="sexo" class="form-label">Sexo</label> <select
								id="sexo" name="sexo" class="form-control">
								<option value="">Seleccione el sexo</option>
								<option value="Masculino">Masculino</option>
								<option value="Femenino">Femenino</option>
								<option value="No definido">No definido</option>
							</select>
						</div>

						<!-- Tel�fono -->
						<div class="col-md-6">
							<label for="telefono" class="form-label">Tel�fono</label> <input
								type="text" id="telefono" name="telefono" class="form-control"
								required placeholder="Ingrese el tel�fono del cliente">
						</div>

						<!-- Nacionalidad y Fecha de nacimiento -->
						<div class="col-md-6">
							<label for="nacionalidad" class="form-label">Nacionalidad</label>
							<select name="nacionalidad" class="form-select" id="nacionalidad">
								<option value="=">Seleccione la nacionalidad</option>
								<%
									ArrayList<Nacionalidad> listaNacionalidades = (ArrayList<Nacionalidad>) request.getAttribute("listaNacionalidades");
									for (Nacionalidad nacionalidad : listaNacionalidades) {
								%>
								<option value="<%=nacionalidad.getId()%>"><%=nacionalidad.getNacionalidad()%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="col-md-6">
							<label for="fechaNacimiento" class="form-label">Fecha de
								Nacimiento</label> <input type="date" id="fechaNacimiento"
								name="fechaNacimiento" class="form-control" required>
						</div>

						<!-- Provincia y Localidad -->
						<div class="col-md-6">
							<label for="provincia" class="form-label">Provincia</label> <select
								id="provincia" name="provincia" class="form-control">
								<option value="">Seleccione la provincia</option>
								<%
									ArrayList<Provincia> listaProvincias = (ArrayList<Provincia>) request.getAttribute("listaProvincias");
									for (Provincia provincia : listaProvincias) {
								%>
								<option value="<%=provincia.getId() %>"><%=provincia.getNombre()%></option>
								<%
									}
								%>
							</select>
						</div>
						<div class="col-md-6">
							<label for="localidad" class="form-label">Localidad</label> <select
								id="localidad" name="localidad" class="form-control">
								<option value="">Seleccione la localidad</option>
								<%
									ArrayList<Localidad> listaLocalidades = (ArrayList<Localidad>) request.getAttribute("listaLocalidades");
									for (Localidad localidad : listaLocalidades) {
								%>
								<option value="<%=localidad.getId()%>"><%=localidad.getNombre()%></option>
								<%
									}
								%>
							</select>
						</div>

						<!-- C�digo Postal, Calle, N�mero -->
						<div class="col-md-4">
							<label for="codigoPostal" class="form-label">C�digo
								Postal</label> <input type="text" id="codigoPostal" name="codigoPostal"
								class="form-control" required placeholder="C�digo Postal">
						</div>
						<div class="col-md-4">
							<label for="calle" class="form-label">Calle</label> <input
								type="text" id="calle" name="calle" class="form-control"
								required placeholder="Calle">
						</div>
						<div class="col-md-4">
							<label for="numero" class="form-label">N�mero</label> <input
								type="text" id="numero" name="numero" class="form-control"
								required placeholder="N�mero">
						</div>
					</div>

					<!-- Botones de acci�n -->
					<div class="button-group mt-4">
						<button type="button" class="btn btn-secondary btn-volver"
							onclick="window.location.href='ListarClientesSv'">Volver</button>
						<button type="submit" class="btn-general btn-nuevo-cliente">Dar
							alta</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
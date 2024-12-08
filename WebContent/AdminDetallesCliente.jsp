<%@ page import="entidad.Cliente"%>
<%@ page import="entidad.Cuenta"%>
<%@ page import="entidad.Prestamo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="Componentes/Head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Banco UTN - Detalles de Cliente</title>
<style>
body {
	margin: 0;
	padding: 0;
	background-color: #f5f5f5;
}

.header {
	background-color: #003b7a;
	color: white;
	padding: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.header h1 {
	margin: 0;
	font-size: 24px;
}

.logout-btn {
	background-color: #2b937b;
	color: white;
	border: none;
	padding: 8px 16px;
	border-radius: 4px;
	cursor: pointer;
}

.container {
	max-width: 1200px;
	margin: 20px auto;
	padding: 0 20px;
}

.page-title {
	font-size: 24px;
	margin-bottom: 20px;
}

.card {
	background-color: white;
	border-radius: 8px;
	box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
	padding: 20px;
}

.card-title, .info-section-title {
	font-family: Arial, sans-serif;
	color: #333;
	font-weight: bold;
	font-size: 20px;
	margin-bottom: 15px;
	border-bottom: 2px solid #e0e0e0;
	padding-bottom: 5px;
}

.info-grid {
	display: flex;
	flex-direction: column;
	gap: 15px;
}

.info-row {
	display: grid;
	grid-template-columns: 200px 1fr;
	gap: 10px;
	align-items: center;
}

.info-grid.two-columns {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.info-column {
	width: 100%;
}

.info-section {
	background-color: transparent;
	padding: 15px;
	border-radius: 6px;
}

.info-label {
	font-weight: bold;
	color: #666;
	text-align: left;
}

.info-row span {
	text-align: left;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

th, td {
	padding: 12px;
	text-align: left;
	border-bottom: 1px solid #ddd;
}

th {
	color: #666;
	font-weight: bold;
}

.balance {
	color: #28a745;
}

.status {
	padding: 4px 8px;
	border-radius: 4px;
	font-size: 14px;
}

.pending {
	background-color: #ffd700;
}

.rejected {
	background-color: #dc3545;
	color: white;
}

.approved {
	background-color: #28a745;
	color: white;
}

.pagination {
	margin-top: 20px;
}

.page-link {
	color: #003b7a; 
	background-color: white;
	border: 1px solid #dee2e6;
}

.page-link:hover {
	background-color: #f0f0f0;
	color: #0056b3;
}

.page-item.active .page-link {
	background-color: #003b7a;
	border-color: #003b7a;
	color: white;
}

.page-item.disabled .page-link {
	color: #6c757d;
	pointer-events: none;
	background-color: #fff;
	border-color: #dee2e6;
}

.pagination-info {
	margin-top: 5px;
    display: inline-block;
    margin-right: 20px;
    font-size: 1rem; 
    margin-right: auto; 
}

</style>
</head>
<body>
	<%@ include file="Componentes/NavbarAdmin.jsp"%>

	<%
		Cliente cliente = (Cliente) request.getAttribute("cliente");

		if (cliente == null) {
			out.print("Cliente no encontrado.");
			return;
		}
		ArrayList<Prestamo> prestamos = (ArrayList<Prestamo>) request.getAttribute("prestamos");
		ArrayList<Cuenta> cuentas = (ArrayList<Cuenta>) request.getAttribute("cuentas");
	%>

	<div class="container">

		<!-- Detalles del cliente -->
		<h2 class="page-title">Detalles de Cliente</h2>
		<div class="card">
			<div class="info-grid two-columns">
				<div class="info-column">
					<div class="info-section">
						<h3 class="info-section-title">Información personal</h3>
						<div class="info-row">
							<span class="info-label">Usuario:</span> <span><%=cliente.getNombreUsuario()%></span>
						</div>
						<div class="info-row">
							<span class="info-label">Nombre y apellido:</span> <span><%=cliente.getNombre() + " " + cliente.getApellido()%></span>
						</div>
						<div class="info-row">
							<span class="info-label">Email:</span> <span><%=cliente.getEmail()%></span>
						</div>
						<div class="info-row">
							<span class="info-label">DNI:</span> <span><%=cliente.getDni()%></span>
						</div>

						<div class="info-row">
							<span class="info-label">Cuil:</span> <span><%=cliente.getCuil()%></span>
						</div>

						<div class="info-row">
							<span class="info-label">Nacionalidad:</span> <span><%=cliente.getNacionalidad().getNacionalidad()%></span>
						</div>

						<div class="info-row">
							<span class="info-label">Sexo:</span> <span><%=cliente.getSexo()%></span>
						</div>

						<div class="info-row">
							<span class="info-label">Fecha de nacimiento:</span> <span><%=cliente.getFechaNacimiento()%></span>
						</div>

						<div class="info-row">
							<span class="info-label">Estado:</span> <span><%=cliente.isEstado() == true ? "Activo" : "Inactivo"%></span>
						</div>
						<div class="info-row">
							<span class="info-label">Teléfono:</span> <span><%=cliente.getNumeroTelefono() != null ? cliente.getNumeroTelefono() : "Sin teléfono"%></span>
						</div>
					</div>
				</div>

				<div class="info-column">
					<div class="info-section">
						<h3 class="info-section-title">Dirección</h3>
						<div class="info-row">
							<span class="info-label">Provincia:</span> <span> <%=cliente.getDireccion() != null && cliente.getDireccion().getProvincia() != null
					? cliente.getDireccion().getProvincia().getNombre()
					: "Sin provincia"%>
							</span>
						</div>
						<div class="info-row">
							<span class="info-label">Localidad:</span> <span> <%=cliente.getDireccion() != null && cliente.getDireccion().getLocalidad() != null
					? cliente.getDireccion().getLocalidad().getNombre()
					: "Sin localidad"%>
							</span>
						</div>
						<div class="info-row">
							<span class="info-label">Código Postal:</span> <span> <%=cliente.getDireccion() != null ? cliente.getDireccion().getCodigoPostal() : "Sin código postal"%>
							</span>
						</div>
						<div class="info-row">
							<span class="info-label">Calle:</span> <span> <%=cliente.getDireccion() != null && cliente.getDireccion().getCalle() != null
					? cliente.getDireccion().getCalle()
					: "Sin calle"%>
							</span>
						</div>
						<div class="info-row">
							<span class="info-label">Altura:</span> <span> <%=cliente.getDireccion() != null && cliente.getDireccion().getNumero() != null
					&& !cliente.getDireccion().getNumero().isEmpty() ? cliente.getDireccion().getNumero()
							: "Sin número"%>
							</span>
						</div>

					</div>
				</div>
			</div>
		</div>

		<!-- Resumen de cuentas -->
		<div class="card">
			<h3 class="card-title">Resumen de cuentas</h3>
			<%
				if (cuentas != null && !cuentas.isEmpty()) {
			%>
			<table>
				<thead>
					<tr>
						<th>Número de cuenta</th>
						<th>CBU</th>
						<th>Fecha de creación</th>
						<th>Tipo de cuenta</th>
						<th>Saldo</th>
					</tr>
				</thead>
				<tbody>
					<%
						for (Cuenta cuenta : cuentas) {
					%>
					<tr>
						<td><%=cuenta.getNumeroCuenta()%></td>
						<td><%=cuenta.getCbu()%></td>
						<td><%=cuenta.getFechaCreacion()%></td>
						<td><%=cuenta.getTipoCuenta().getTipo()%></td>
						<td class="balance">$<%=cuenta.getSaldo()%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				} else {
			%>
			<p>No se encontraron cuentas para este cliente.</p>
			<%
				}
			%>
		</div>

		<!-- Resumen de préstamos -->
		<div class="card">
			<h3 class="card-title">Resumen de préstamos</h3>
			<%
				if (prestamos != null && !prestamos.isEmpty()) {
			%>
			<table>
				<thead>
					<tr>
						<th>ID</th>
						<th>Tipo de préstamo</th>
						<th>Monto pedido</th>
						<th>Monto a pagar</th>
						<th>Cuotas</th>
						<th>Estado</th>
					</tr>
				</thead>
				<tbody>
					<%
						for (Prestamo prestamo : prestamos) {
					%>
					<tr>
						<td><%=prestamo.getIdPrestamo()%></td>
						<td><%=prestamo.getTipoPrestamo().getNombreTipoPrestamo()%></td>
						<td><%=prestamo.getMontoPedido()%></td>
						<td><%=prestamo.getMontoAPagar()%></td>
						<td><%=prestamo.getCuotas()%></td>
						<td>
							<%
								int estadoInt = prestamo.getEstado();
										String estado = "";
										String claseEstado = "";
										if (estadoInt == 0) {
											estado = "Pendiente";
											claseEstado = "pending";
										} else if (estadoInt == 1) {
											estado = "Aprobado";
											claseEstado = "approved";
										} else if (estadoInt == 2) {
											estado = "Rechazado";
											claseEstado = "rejected";
										}
							%> <span class="status <%=claseEstado%>"><%=estado%></span>
						</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>

			<!-- Paginación -->
			<%
				Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
					Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
					Integer paginaActual = (Integer) request.getAttribute("paginaActual");
					if (totalPrestamos > 3) {
			%>
			<nav aria-label="Paginación de préstamos">
				<ul class="pagination justify-content-end">
					<div class="pagination-info">
						Mostrando página
						<%=request.getAttribute("paginaActual")%>
						de
						<%=request.getAttribute("totalPaginas")%>
					</div>
					<!-- Botón Anterior -->
					<li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
						<a class="page-link"
						<%=paginaActual == 1 ? ""
							: "href='DetalleClienteSv?idCliente=" + cliente.getIdCliente() + "&page="
									+ (paginaActual - 1) + "&pageSize=3'"%>>
							Anterior </a>
					</li>

					<%
					int startPage = Math.max(1, paginaActual - 1);
					int endPage = Math.min(totalPaginas, startPage + 2);

					if (endPage - startPage < 2) {
						startPage = Math.max(1, endPage - 2);
					}

					if (startPage > 1) { 
					%>
						<li class="page-item"><a class="page-link"
							href="DetalleClienteSv?idCliente=<%=cliente.getIdCliente()%>&page=1&pageSize=3">1</a>
						</li>
						<li class="page-item disabled"><span class="page-link">...</span>
						</li>
					<%
					}

					for (int i = startPage; i <= endPage; i++) {
					%>
					<li class="page-item <%=i == paginaActual ? "active" : ""%>">
						<a class="page-link"
						href="DetalleClienteSv?idCliente=<%=cliente.getIdCliente()%>&page=<%=i%>&pageSize=3">
							<%=i%>
					</a>
					</li>
					<%
						}

					if (endPage < totalPaginas) {
					%>
					<li class="page-item disabled"><span class="page-link">...</span>
					</li>
					<li class="page-item"><a class="page-link"
						href="DetalleClienteSv?idCliente=<%=cliente.getIdCliente()%>&page=<%=totalPaginas%>&pageSize=3">
							<%=totalPaginas%>
					</a></li>
					<%
						}
					%>

					<li
						class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
						<a class="page-link"
						<%=paginaActual == totalPaginas ? ""
							: "href='DetalleClienteSv?idCliente=" + cliente.getIdCliente() + "&page="
									+ (paginaActual + 1) + "&pageSize=3'"%>>
							Siguiente </a>
					</li>
				</ul>
			</nav>
			<%
				}
			%>
			<%
				} else {
			%>
			<p>No se registraron préstamos para el cliente.</p>
			<%
				}
			%>
		</div>
	</div>

</body>
</html>
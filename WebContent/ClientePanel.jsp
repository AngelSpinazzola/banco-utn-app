<%@ page import="entidad.Cliente"%>
<%@ page import="entidad.Cuenta"%>
<%@ page import="entidad.Movimiento"%>
<%@ page import="java.util.ArrayList"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="../Componentes/Head.jsp"%>
<meta charset="UTF-8">
<style>
body {
	background-color: #f9f9f9;
}

.main-container {
	max-width: 1300px;
	margin: 0 auto;
	padding: 20px;
	margin-top: 40px;
}

.section-title {
	color: #333;
	margin-top: 20px;
}

.account-cards {
	display: flex;
	gap: 20px;
	justify-content: center;
	margin-top: 20px;
}

.account-card {
	border: 1px solid #d1d1d1;
	border-radius: 20px;
	padding: 20px;
	width: 382px;
	text-align: left;
	background-color: #fff;
}

.account-card h3 {
	margin: 0;
	font-size: 18px;
	color: #333;
}

.account-card p {
	margin: 5px 0;
	font-size: 14px;
}

.account-card button {
	background-color: #0066cc;
	color: white;
	border: none;
	padding: 5px 10px;
	border-radius: 5px;
	cursor: pointer;
}

.cuenta-card {
	border: 1px solid #ddd;
	border-radius: 8px;
	transition: transform 0.2s;
	background-color: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.cuenta-card:hover {
	transform: scale(1.03);
}

.card-header {
	font-weight: bold;
}

.card-footer {
	background-color: white;
	border-top: none;
	box-shadow: none;
	padding: 0.5rem;
}

.card-footer button {
	min-width: 90px;
}

.card-body p {
	margin: 0;
	line-height: 1.5;
}

.seccion-cartas .col-12.col-md-4 {
	width: 30%;
}

.seccion-cartas {
	margin-right: -15px;
}

.transactions-table .negative {
	color: red;
}

.transactions-table .positive {
	color: green;
}

.container-cards {
	display: flex;
	justify-content: space-between;
	gap: 20px;
}

.card-footer .btn-outline-primary, .card-footer .btn-outline-success {
	color: black !important;
	border: 1px solid black !important;
}

.card-footer .btn-outline-primary:hover, .card-footer .btn-outline-success:hover
	{
	background-color: black !important;
	color: white !important;
}

.section-title {
	font-size: 1.8rem;
	color: #333;
	font-weight: 600;
}

.table {
	background-color: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.table th, .table td {
	vertical-align: middle;
	padding: 12px 15px;
}

.text-danger {
	color: #dc3545 !important;
}

.text-success {
	color: #28a745 !important;
}

.table-striped tbody tr:nth-of-type(odd) {
	background-color: #f8f9fa;
}

.table-striped tbody tr:hover {
	background-color: #f1f1f1;
}

.table-responsive {
	overflow-x: auto;
}

.table th {
	text-align: center;
}

.table td {
	text-align: center;
}

.pagination-container {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 20px;
}

.pagination {
	margin-top: 20px;
}

.pagination button {
	background-color: #aac4ee;
	border: none;
	color: white;
	padding: 8px 16px;
	text-decoration: none;
	font-size: 16px;
	margin: 4px 2px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	border-radius: 2px;
}

.pagination button:hover {
	background-color: #2F4E93;
	color: white;
}

.pagination button.active {
	text-color: white;
	background-color: #2F4E93;
	color: white;
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

	<%@ include file="../Componentes/Navbar.jsp"%>
	<form action="ClientePanelSv" method="post">
	<!-- Sección de cuentas -->
	<div class="main-container">
		<%
			Cliente cliente = (Cliente) request.getAttribute("cliente");
			ArrayList<Cuenta> cuentas = (ArrayList<Cuenta>) request.getAttribute("cuentas");
			ArrayList<Movimiento> movimientos = (ArrayList<Movimiento>) request.getAttribute("movimientos");
		%>
		<h5>
			Bienvenido/a
			<%=cliente.getNombre() + " " + cliente.getApellido()%>
		</h5>

		<div class="container-cards mb-4">
			<%
				if (cuentas != null && !cuentas.isEmpty()) {
					for (Cuenta cuenta : cuentas) {
			%>
			<div class="card cuenta-card w-100">
				<div
					class="card-header <%=cuenta.getTipoCuenta().getTipo().equalsIgnoreCase("Caja de Ahorro") ? "text-primary"
							: "text-success"%>">
					<%=cuenta.getTipoCuenta().getTipo().equalsIgnoreCase("Caja de Ahorro") ? "Caja de Ahorro"
							: "Cuenta corriente"%>
				</div>
				<div class="card-body">
					<p>
						<strong>N° Cuenta:</strong>
						<%=cuenta.getNumeroCuenta()%>
					</p>
					<p>
						<strong>CBU:</strong>
						<%=cuenta.getCbu()%>
					</p>
					<p>
						<strong>Saldo:</strong> $<%=cuenta.getSaldo()%></p>
				</div>
			</div>
			<%
				}
				} else {
			%>
			<p>No se encontraron cuentas para este cliente.</p>
			<%
				}
			%>
		</div>

		<!-- Tabla de últimos movimientos -->
		<div>
			<h5>Resumen de movimientos</h5>

			<%
				if (movimientos != null && !movimientos.isEmpty()) {
			%>
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>ID Cuenta</th>
						<th>Tipo de movimiento</th>
						<th>Detalle</th>
						<th>Monto</th>
						<th>Fecha</th>
					</tr>
				</thead>
				<tbody>
					<%
						for (Movimiento movimiento : movimientos) {
					%>
					<tr>
						<td><%=movimiento.getIdCuentaReceptor()%></td>
						<td><%=movimiento.getTipoMovimiento().getNombre()%></td>
						<td><%=movimiento.getDetalle()%></td>
						<td class="monto"><span class="signo-dolar">$</span><%=movimiento.getMonto()%></td>
						<td><%=movimiento.getFecha()%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
					Integer totalMovimientos = (Integer) request.getAttribute("totalMovimientos");
					Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
					Integer paginaActual = (Integer) request.getAttribute("paginaActual");
					if (totalMovimientos > 6) {
			%>
			<nav aria-label="Paginación de préstamos" class="text-center"
				style="margin-top: 50px;">
				<ul class="pagination justify-content-center">
					<div class="pagination-info">
						Mostrando página
						<%=paginaActual%>
						de
						<%=totalPaginas%>
					</div>
					<li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
						<a class="page-link"
						<%=paginaActual == 1 ? ""
							: "href='ClientePanelSv?page=" + (paginaActual - 1) + "&pageSize=5'"%>>
							Anterior  </a>
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
						href="ClientePanelSv?page=1&pageSize=5">1</a></li>
					<li class="page-item disabled"><span class="page-link">...</span>
					</li>
					<%
						}

								for (int i = startPage; i <= endPage; i++) {
					%>
					<li class="page-item <%=i == paginaActual ? "active" : ""%>">
						<a class="page-link"
						href="ClientePanelSv?page=<%=i%>&pageSize=5"> <%=i%>
					</a>
					</li>
					<%
						}

								if (endPage < totalPaginas) {
					%>
					<li class="page-item disabled"><span class="page-link">...</span>
					</li>
					<li class="page-item"><a class="page-link"
						href="ClientePanelSv?page=<%=totalPaginas%>&pageSize=5">
							<%=totalPaginas%>
					</a></li>
					<%
						}
					%>

					<li
						class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
						<a class="page-link"
						<%=paginaActual == totalPaginas ? ""
							: "href='ClientePanelSv?page=" + (paginaActual + 1) + "&pageSize=5'"%>>
							Siguiente  </a>
					</li>
				</ul>
			</nav>
			<%
				}
			%>
			<%
				} else {
			%>
			<p class="text-center">No se registraron movimientos.</p>
			<%
				}
			%>
		</div>
	</div>
	</form>
</body>
</html>
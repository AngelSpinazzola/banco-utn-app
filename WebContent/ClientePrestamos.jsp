<%@ page import="entidad.Prestamo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<%@ include file="Componentes/Head.jsp"%>
<title>Pago de cuotas</title>
<style>
.container {
	max-width: 1300px;
	margin: 0 auto;
	padding: 15px;
}

.table {
	background-color: #fff;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.table.table-striped th, .table.table-striped td {
	padding: 16px !important;
	vertical-align: middle !important;
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
	flex-direction: column;
	align-items: center;
	margin-top: 20px;
}

.pagination {
	margin-top: 20px !important;
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
	display: flex;
	justify-content: flex-start;
	align-items: center;
	margin-top: 5px;
	font-size: 1rem;
}

.pagination-info p {
	margin: 0;
	margin-right: 60px !important;
}

.titulo {
	padding-top: 30px;
	margin-bottom: 30px;
}

.estado-aprovado {
	color: #28a745;
	font-weight: bold;
}

.empty-state {
	text-align: center;
	padding: 6rem 2rem;
	border-radius: 12px;
}

.empty-state-icon {
	font-size: 4rem;
	color: var(- -color-muted);
	margin-bottom: 1rem;
}

.empty-state h3 {
	font-size: 1.5rem;
	margin-bottom: 1rem;
}

.empty-state p {
	color: var(- -color-muted);
	margin-bottom: 1.5rem;
}

.btn-solicitar {
	display: inline-block;
	background-color: #4a90e2;
	color: white;
	padding: 0.75rem 1.5rem;
	text-decoration: none;
	border-radius: 8px;
	transition: all 0.3s ease;
}

.btn-solicitar:hover {
	background-color: #3a7bd5;
	transform: translateY(-2px);
}
</style>
</head>
<body>
	<jsp:include page="Componentes/Navbar.jsp"></jsp:include>

	<div class="container mt-5" style="margin-bottom: 40px;">
		<%
			ArrayList<Prestamo> listaPrestamos = (ArrayList<Prestamo>) request.getAttribute("listaPrestamos");
			Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");

			if (totalPrestamos > 0) {
		%>
		<h4 class="card-title text-left" style="margin-bottom: 40px;">Mis
			préstamos activos</h4>
		<table class="table table-striped table-hover">
			<thead>
				<tr>
					<th>ID Préstamo</th>
					<th>Tipo de préstamo</th>
					<th>Monto pedido</th>
					<th>Importe a pagar</th>
					<th>Cuotas totales</th>
					<th>Cuotas abonadas</th>
					<th>Fecha de alta</th>
					<th>Acción</th>
				</tr>
			</thead>
			<tbody>
				<%
					}
				%>
				<%
					Iterator<Prestamo> iteradorPrestamos = listaPrestamos.iterator();
					while (iteradorPrestamos.hasNext()) {
						Prestamo prestamo = iteradorPrestamos.next();
				%>
				<tr>
					<td><%=prestamo.getIdPrestamo()%></td>
					<td><%=prestamo.getTipoPrestamo().getNombreTipoPrestamo()%></td>
					<td><%=prestamo.getMontoPedido()%></td>
					<td><%=prestamo.getMontoAPagar()%></td>
					<td><%=prestamo.getCuotas()%></td>
					<td><%=prestamo.getCuotasPagas()%></td>
					<td><%=prestamo.getFecha()%></td>
					<td>
						<form action="ClientePagarCuotasSv" method="post">
							<input type="hidden" name="idPrestamo" value="<%=prestamo.getIdPrestamo()%>"> 
							<button type="submit" class="btn btn-outline-success">Pagar cuotas</button>
						</form>
					</td>
				</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<%
			Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
			Integer paginaActual = (Integer) request.getAttribute("paginaActual");

			if (totalPrestamos > 0) {
		%>
		<nav aria-label="Paginación de clientes" class="text-center">
			<ul class="pagination justify-content-center">
				<div class="pagination-info">
					<p>
						Mostrando página
						<%=paginaActual%>
						de
						<%=totalPaginas%></p>
				</div>
				<li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
					<a class="page-link"
					<%=paginaActual == 1 ? ""
						: "href='ClientePrestamosSv?page=" + (paginaActual - 1) + "&pageSize=6'"%>>
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
					href="ClientePrestamosSv?page=1&pageSize=6">1</a></li>
				<li class="page-item disabled"><span class="page-link">...</span>
				</li>
				<%
					}

						for (int i = startPage; i <= endPage; i++) {
				%>
				<li class="page-item <%=i == paginaActual ? "active" : ""%>"><a
					class="page-link" href="ClientePrestamosSv?page=<%=i%>&pageSize=5">
						<%=i%>
				</a></li>
				<%
					}

						if (endPage < totalPaginas) {
				%>
				<li class="page-item disabled"><span class="page-link">...</span></li>
				<li class="page-item"><a class="page-link"
					href="ClientePrestamosSv?page=<%=totalPaginas%>&pageSize=6"><%=totalPaginas%></a></li>
				<%
					}
				%>
				<li
					class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
					<a class="page-link"
					<%=paginaActual == totalPaginas ? ""
						: "href='ClientePrestamosSv?page=" + (paginaActual + 1) + "&pageSize=6'"%>>
						Siguiente </a>
				</li>
			</ul>
		</nav>
		<%
			} else {
		%>
		<div class="empty-state">
			<div class="empty-state-icon">💸</div>
			<h3>No tenés préstamos activos</h3>
			<p>Parece que aún no has solicitado ningún préstamo. ¿Querés
				solicitar uno?</p>
			<a href="ClienteSolicitudPrestamoSv" class="btn-solicitar">Solicitar
				préstamo</a>
		</div>
		<%
			}
		%>
	</div>

</body>
</html>
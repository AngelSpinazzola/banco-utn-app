<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="entidad.Prestamo"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html lang="es"><meta charset="UTF-8">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Solicitudes de préstamos</title>
    <style>
	   	.container {
		    max-width: 1400px;  
		    margin: 0 auto;
		    padding: 15px;
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
		.btn {
		    font-size: 0.875rem; 
		    padding: 3px 5px; 
		    border-radius: 4px; 
		    transition: background-color 0.3s ease, color 0.3s ease;
		}
		.btn-outline-success {
		    color: #28a745;
		    border-color: #28a745;
		    transition: background-color 0.3s ease, color 0.3s ease;
		}
		.btn-outline-danger {
		    color: #dc3545;
		    border-color: #dc3545;
		    transition: background-color 0.3s ease, color 0.3s ease;
		}
		.btn-outline-success:hover {
		    background-color: #28a745;
		    color: black;
		}
		.btn-outline-danger:hover {
		    background-color: #dc3545;
		    color: white;
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
    <%@ include file="Componentes/Head.jsp"%>
</head>
<body>

    <%@ include file="Componentes/NavbarAdmin.jsp"%>

    <div class="container mt-5" style="margin-bottom: 40px;">
    <h4 class="card-title text-left" style="margin-bottom: 40px;">Solicitudes de préstamos pendientes</h4>
    <%
        ArrayList<Prestamo> listaPrestamos = (ArrayList<Prestamo>) request.getAttribute("listaPrestamos");
        if (listaPrestamos != null && !listaPrestamos.isEmpty()) {
    %>
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>Cliente</th>
                <th>DNI</th>
                <th>Tipo de préstamo</th>
                <th>Monto solicitado</th>
                <th>Monto a pagar</th>
                <th>Cuotas</th>
                <th>Fecha</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Prestamo prestamo : listaPrestamos) {
            %>
            <tr>
                <td><%=prestamo.getCliente().getNombre() + " " + prestamo.getCliente().getApellido()%></td>
                <td><%=prestamo.getCliente().getDni()%></td>
                <td><%=prestamo.getTipoPrestamo().getNombreTipoPrestamo()%></td>
                <td>$<%=prestamo.getMontoPedido()%></td>
                <td>$<%=prestamo.getMontoAPagar()%></td>
                <td><%=prestamo.getCuotas()%></td>
                <td><%=prestamo.getFecha()%></td>
                <td>
                    <button class="btn btn-outline-success" onclick="aprobarPrestamo(<%=prestamo.getIdPrestamo()%>)">Aprobar</button>
                    <button class="btn btn-outline-danger" onclick="rechazarPrestamo(<%=prestamo.getIdPrestamo()%>)">Rechazar</button>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    
    <%
        Integer totalPrestamos = (Integer) request.getAttribute("totalPrestamos");
        Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
        Integer paginaActual = (Integer) request.getAttribute("paginaActual");
        if (totalPrestamos > 5) {
    %>
    <nav aria-label="Paginación de préstamos" class="text-center">
        <ul class="pagination justify-content-center">
            <div class="pagination-info">
                Mostrando página <%=paginaActual%> de <%=totalPaginas%>
            </div>
            <li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
                <a class="page-link"
                   <%=paginaActual == 1 ? "" : "href='AdminSolicitudesPrestamosSv?page=" + (paginaActual - 1) + "&pageSize=5'"%>>
                    Anterior 
                </a>
            </li>

            <%
                int startPage = Math.max(1, paginaActual - 1);
                int endPage = Math.min(totalPaginas, startPage + 2);

                if (endPage - startPage < 2) {
                    startPage = Math.max(1, endPage - 2);
                }

                if (startPage > 1) {
            %>
            <li class="page-item">
                <a class="page-link" href="AdminSolicitudesPrestamosSv?page=1&pageSize=5">1</a>
            </li>
            <li class="page-item disabled">
                <span class="page-link">...</span>
            </li>
            <%
                }

                for (int i = startPage; i <= endPage; i++) {
            %>
            <li class="page-item <%=i == paginaActual ? "active" : ""%>">
                <a class="page-link" href="AdminSolicitudesPrestamosSv?page=<%=i%>&pageSize=5">
                    <%=i%>
                </a>
            </li>
            <%
                }

                if (endPage < totalPaginas) {
            %>
            <li class="page-item disabled">
                <span class="page-link">...</span>
            </li>
            <li class="page-item">
                <a class="page-link" href="AdminSolicitudesPrestamosSv?page=<%=totalPaginas%>&pageSize=5">
                    <%=totalPaginas%>
                </a>
            </li>
            <%
                }
            %>

            <li class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
                <a class="page-link"
                   <%=paginaActual == totalPaginas ? "" : "href='AdminSolicitudesPrestamosSv?page=" + (paginaActual + 1) + "&pageSize=5'"%>>
                    Siguiente 
                </a>
            </li>
        </ul>
    </nav>
    <%
        }
    %>
    <%
        } else {
    %>
    <p class="text-center">No se registraron solicitudes de préstamos pendientes.</p>
    <%
        }
    %>
</div>

</body>
</html>


<%@ page import="entidad.Prestamo"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <title>Préstamos activos</title>
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
		.table.table-striped th, 
		.table.table-striped td {
	    	padding: 21.5px !important;
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
		.estado-en-curso {
		    background-color: #ffeb99; /* Amarillo claro */
		    color: #856404; /* Marrón oscuro */
		    font-weight: bold;
		    border: 1px solid #ffd966; /* Borde amarillo */
		    border-radius: 5px;
		    text-align: center;
		    padding: 5px;
		}
		
		.estado-finalizado {
		    background-color: #d4edda; /* Verde claro */
		    color: #155724; /* Verde oscuro */
		    font-weight: bold;
		    border: 1px solid #c3e6cb; /* Borde verde */
		    border-radius: 5px;
		    text-align: center;
		    padding: 5px;
		}
		
    </style>
	<%@ include file="Componentes/Head.jsp"%>
</head>
<body>
	<%@ include file="Componentes/NavbarAdmin.jsp"%>
	
    <div class="container mt-5" style="margin-bottom: 40px;">
        <h4 class="card-title text-left" style="margin-bottom: 40px;">Préstamos</h4>
        <%
            ArrayList<Prestamo> prestamos = (ArrayList<Prestamo>) request.getAttribute("prestamos");
            if (prestamos != null && !prestamos.isEmpty()) {
        %>
        <table class="table table-striped table-hover">
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Tipo de préstamo</th>
                    <th>Monto solicitado</th>
                    <th>Monto a pagar</th>
                    <th>Cuotas</th>
                    <th>Cuotas pagas</th>
                    <th>Fecha </th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Prestamo prestamo : prestamos) {
                %>
                <tr>
                    <td><%= prestamo.getCliente().getNombre() + " " + prestamo.getCliente().getApellido()%></td>
                    <td><%= prestamo.getTipoPrestamo().getNombreTipoPrestamo()%></td>
                    <td>$<%= prestamo.getMontoPedido()%></td>
                    <td>$<%= prestamo.getMontoAPagar()%></td>
                    <td><%= prestamo.getCuotas()%></td>
                    <td><%= prestamo.getCuotasPagas() %></td>
                    <td><%= prestamo.getFecha()  %></td>
                    <td>
                    <%
                    	int estadoInt = prestamo.getEstado();
                    	String estado = "";
                    	String claseEstado = "";
                    	if(estadoInt == 1){
                    		estado = "En curso";
                    		claseEstado = "estado-en-curso";
                    	} else if (estadoInt == 3) {
                    		estado = "Finalizado";
                    		claseEstado = "estado-finalizado";
                    	}
                    %> 
                    <span class="status <%=claseEstado%>"><%=estado%></span>
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
        <nav aria-label="Paginación de préstamos" class="text-center" style="margin-top: 50px;">
	        <ul class="pagination justify-content-center">
	            <div class="pagination-info">
	                Mostrando página <%=paginaActual%> de <%=totalPaginas%>
	            </div>
	            <li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
	                <a class="page-link"
	                   <%=paginaActual == 1 ? "" : "href='AdminPrestamosSv?page=" + (paginaActual - 1) + "&pageSize=5'"%>>
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
	                <a class="page-link" href="AdminPrestamosSv?page=1&pageSize=5">1</a>
	            </li>
	            <li class="page-item disabled">
	                <span class="page-link">...</span>
	            </li>
	            <%
	                }
	
	                for (int i = startPage; i <= endPage; i++) {
	            %>
	            <li class="page-item <%=i == paginaActual ? "active" : ""%>">
	                <a class="page-link" href="AdminPrestamosSv?page=<%=i%>&pageSize=5">
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
	                <a class="page-link" href="AdminPrestamosSv?page=<%=totalPaginas%>&pageSize=5">
	                    <%=totalPaginas%>
	                </a>
	            </li>
	            <%
	                }
	            %>
	
	            <li class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
	                <a class="page-link"
	                   <%=paginaActual == totalPaginas ? "" : "href='AdminPrestamosSv?page=" + (paginaActual + 1) + "&pageSize=5'"%>>
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
        <p class="text-center">No se registraron préstamos.</p>
        <%
            }
        %>
    </div>

</body>
</html>
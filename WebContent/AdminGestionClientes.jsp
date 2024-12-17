<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="entidad.Cliente"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
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
	
	.table.table-striped th, .table.table-striped td {
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
	
	.btn-nuevo-cliente-container {
	    display: flex;
	    justify-content: flex-end;
	    margin-bottom: 10px;
	    position: relative;
	    top: -20px; 
	    z-index: 1; 
	}
	
	.btn-nuevo-cliente {
	    width: 200px;
	}
	
	.action-buttons {
		position: relative;
	}
	
	.action-buttons button {
		background-color: transparent;
		border: none;
		cursor: pointer;
	}
	
	.action-dropdown {
		display: none;
		position: absolute;
		background-color: #f1f1f1;
		min-width: 120px;
		box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
		z-index: 1;
	}
	
	.action-dropdown a {
		color: black;
		padding: 12px 16px;
		text-decoration: none;
		display: block;
	}
	
	.action-dropdown a:hover {
		background-color: #ddd;
	}
	
	.action-buttons:hover .action-dropdown {
		display: block;
	}
	.titulo {
		padding-top: 20px;
	}
</style>
<%@ include file="Componentes/Head.jsp"%>
</head>
<body>
	<%@ include file="Componentes/NavbarAdmin.jsp"%>
	<div class="container">
		<h3 class="titulo">Gestión de clientes</h3>
		<div class="btn-nuevo-cliente-container">
			<a href="AltaClienteSv">
				<button class="btn-general btn-nuevo-cliente" style="margin-buttom: 10px !important;">Nuevo Cliente</button>
			</a>
		</div>
		<div class="client-table-container">
			<table class="table table-striped table-hover">
				<thead>
					<tr>
						<th>DNI</th>
						<th>Nombre</th>
						<th>Apellido</th>
						<th>Cuentas</th>
						<th>Estado</th>
						<th>Acción</th>
					</tr>
				</thead>
				<tbody>
					<%
						ArrayList<Cliente> listaClientes = (ArrayList<Cliente>) request.getAttribute("listaClientes");
						Iterator<Cliente> iteradorClientes = listaClientes.iterator();
						while (iteradorClientes.hasNext()) {
							Cliente cliente = iteradorClientes.next();
					%>
					<tr>
						<td><%=cliente.getDni()%></td>
						<td><%=cliente.getNombre()%></td>
						<td><%=cliente.getApellido()%></td>
						<td><%=cliente.getCantidadCuentas()%></td>
						<td><%=cliente.isEstado() ? "Activo" : "Inactivo"%> <i
							class="<%=cliente.isEstado() ? "fas fa-check-circle" : "fas fa-times-circle"%>"
							style="color: <%=cliente.isEstado() ? "#28a745" : "#dc3545"%>;"></i>
						</td>
						<td>
							<div class="action-buttons">
								<button>
									<i class="fas fa-ellipsis-v"></i>
								</button>
								<div class="action-dropdown">
									<a href="DetalleClienteSv?idCliente=<%=cliente.getIdCliente()%>">Ver Cliente</a> 
									<a href="EditarClienteSv?idCliente=<%=cliente.getIdCliente()%>">Editar Cliente</a> 
									<a href="AdminCuentasClienteSv?idCliente=<%=cliente.getIdCliente()%>">Gestionar Cuentas</a> 
									<a href="BajaClienteSv?idCliente=<%=cliente.getIdCliente()%>">Eliminar Cliente</a>
								</div>
							</div>
						</td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
			<%
				Integer totalClientes = (Integer) request.getAttribute("totalClientes");
				Integer totalPaginas = (Integer) request.getAttribute("totalPages");
				Integer paginaActual = (Integer) request.getAttribute("currentPage");

				if (totalClientes > 0) {
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
						<%=paginaActual == 1 ? "" : "href='ListarClientesSv?page=" + (paginaActual - 1) + "&pageSize=6'"%>>
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
						href="ListarClientesSv?page=1&pageSize=6">1</a></li>
					<li class="page-item disabled"><span class="page-link">...</span>
					</li>
					<%
						}

							for (int i = startPage; i <= endPage; i++) {
					%>
					<li class="page-item <%=i == paginaActual ? "active" : ""%>"><a
						class="page-link" href="ListarClientesSv?page=<%=i%>&pageSize=5">
							<%=i%>
					</a></li>
					<%
						}

							if (endPage < totalPaginas) {
					%>
					<li class="page-item disabled"><span class="page-link">...</span></li>
					<li class="page-item"><a class="page-link"
						href="ListarClientesSv?page=<%=totalPaginas%>&pageSize=6"><%=totalPaginas%></a></li>
					<%
						}
					%>
					<li
						class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
						<a class="page-link"
						<%=paginaActual == totalPaginas
						? ""
						: "href='ListarClientesSv?page=" + (paginaActual + 1) + "&pageSize=6'"%>>
							Siguiente </a>
					</li>
				</ul>
			</nav>
			<%
				} else {
			%>
			<p class="text-center">No se registraron clientes.</p>
			<%
				}
			%>
		</div>
	</div>


	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
		document.addEventListener('DOMContentLoaded', function() {
		    // Primer bloque: Confirmación de eliminación
		    const deleteLinks = document.querySelectorAll('a[href^="BajaClienteSv"]');
		    
		    deleteLinks.forEach(link => {
		        link.addEventListener('click', function(e) {
		            e.preventDefault();
		            const clienteUrl = this.getAttribute('href');
		            
		            Swal.fire({
		                title: '¿Estás seguro?',
		                text: 'Esta acción eliminará el cliente',
		                icon: 'warning',
		                showCancelButton: true,
		                confirmButtonColor: '#3085d6',
		                cancelButtonColor: '#d33',
		                confirmButtonText: 'Sí, eliminar',
		                cancelButtonText: 'Cancelar'
		            }).then((result) => {
		                if (result.isConfirmed) {
		                    window.location.href = clienteUrl;
		                }
		            });
		        });
		    });
		
		    const mensajeExito = '<%=session.getAttribute("mensajeExito") != null ? session.getAttribute("mensajeExito") : ""%>';
		    const mensajeError = '<%=session.getAttribute("mensajeError") != null ? session.getAttribute("mensajeError") : ""%>';
		
		    if (mensajeExito) {
		        Swal.fire({
		            icon: 'success',
		            title: 'Éxito',
		            text: mensajeExito,
		            confirmButtonText: 'Aceptar'
		        });
		        <%session.removeAttribute("mensajeExito");%>
		    }
		
		    if (mensajeError) {
		        Swal.fire({
		            icon: 'error',
		            title: 'Error',
		            text: mensajeError,
		            confirmButtonText: 'Aceptar'
		        });
		        <%session.removeAttribute("mensajeError");%>
		    }
		});
	</script>
</body>
</html>
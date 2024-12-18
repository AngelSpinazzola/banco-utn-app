<%@ page import="entidad.Prestamo"%>
<%@ page import="entidad.Cuota"%>
<%@ page import="entidad.Cuenta"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<title>Aboná tus cuotas</title>
<%@ include file="Componentes/Head.jsp"%>
<style>
.bg-blue-light {
	background-color: #f1f8ff;
}

.btn-primary-custom {
	background-color: #007bff;
	border: none;
}

.btn-primary-custom:hover {
	background-color: #0056b3;
}

.oscuro-texto {
	color: #333;
}
.disabled-link {
    opacity: 0.5;
    cursor: not-allowed;
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

</style>
</head>
<body>
	<jsp:include page="Componentes/Navbar.jsp"></jsp:include>

	<form method="post" action="ClientePagarCuotasSv" id="pagarCuotasForm">
		<%
			Integer idPrestamo = (Integer) session.getAttribute("idPrestamo");
		%>
		<input type="hidden" name="idPrestamo" value="<%=idPrestamo%>">

		<div class="container mt-5">
			<%
				ArrayList<Cuota> listaCuotas = (ArrayList<Cuota>) request.getAttribute("listaCuotas");
			%>
			<div class="card">
				<div class="card-body">
					<!-- Información del préstamo -->
					<div class="d-flex justify-content-between align-items-start mb-4">
						<div>
							<p class="mb-1">
								<strong class="highlight-bold oscuro-texto">Tipo de
									Préstamo:</strong> Personal
							</p>
						</div>
						<div>
							<p class="mb-1">
								<strong class="highlight-bold oscuro-texto">Cuotas
									Totales:</strong> 15
							</p>
							<p class="mb-1">
								<strong class="highlight-bold oscuro-texto">Cuotas
									Pagadas:</strong> 10
							</p>
						</div>
					</div>

					<!-- Selección de cuenta -->
					<%
						ArrayList<Cuenta> cuentas = (ArrayList<Cuenta>) request.getAttribute("cuentas");
					%>
					<div class="mb-4">
						<label for="selectCuenta" class="form-label">Seleccioná una cuenta para el pago</label> 
						<select name="idCuenta" class="form-select" required>
							<%
								for (Cuenta cuenta : cuentas) {
							%>
							<option value="<%=cuenta.getIdCuenta()%>">N° Cuenta:
								<%=cuenta.getNumeroCuenta()%> - Saldo: $<%=cuenta.getSaldo()%>
							</option>
							<%
								}
							%>
							
						</select>
					</div>

					<!-- Tabla de cuotas -->
					<div class="table-responsive">
						<table class="table">
							<thead class="table-light">
								<tr>
									<th scope="col">N° de Cuota</th>
									<th scope="col">Monto</th>
									<th scope="col">Fecha de Vencimiento</th>
									<th scope="col">Fecha de Pago</th>
									<th scope="col">Seleccionar</th>
									<th scope="col">Estado</th>
								</tr>
							</thead>
							<tbody>
								<%
									Iterator<Cuota> iteradorCuotas = listaCuotas.iterator();
									while (iteradorCuotas.hasNext()) {
										Cuota cuota = iteradorCuotas.next();
								%>
								<tr>
									<td><%=cuota.getNumeroDeCuota()%></td>
									<td><%=cuota.getImporteCuota()%></td>
									<td><%=cuota.getFechaVencimientoCuota()%></td>
									<%
										if (cuota.isEstado() == 1) {
									%>
									<td><%=cuota.getFechaPagoCuota()%></td>
									<td>-</td>
									<%
										} else {
									%>
									<td>-</td>
									<td><input type="checkbox" name="selectedCuotas"
										value="<%=cuota.getIdPlazo()%>"
										class="form-check-input cuota-checkbox"></td>
									<%
										}
									%>
									<td>
                                   	<%
                                    	java.util.Date fechaActual = new java.util.Date();
                                    	java.util.Date fechaVencimiento = cuota.getFechaVencimientoCuota();
                                    	
										int estadoInt = cuota.isEstado();
										String estado = "";
										String claseEstado = "";
										 if (estadoInt == 0 && fechaVencimiento.before(fechaActual)) {
								            estado = "Vencida";
								            claseEstado = "rejected"; 
								        } else if (estadoInt == 0) {
								            estado = "Pendiente";
								            claseEstado = "pending"; 
								        } else if (estadoInt == 1) {
								            estado = "Pagada";
								            claseEstado = "approved"; 
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
					</div>

					<%
						Integer totalPaginas = (Integer) request.getAttribute("totalPaginas");
						Integer paginaActual = (Integer) request.getAttribute("paginaActual");
						Integer totalCuotas = (Integer) request.getAttribute("totalCuotas");
					%>
					<!-- Paginación existente -->
					<nav aria-label="Paginación de clientes" class="text-center">
						<ul class="pagination justify-content-center">
							<li class="page-item <%=paginaActual == 1 ? "disabled" : ""%>">
								<a class="page-link"
								<%=paginaActual == 1 ? "" : "href='ClientePagarCuotasSv?page=" + (paginaActual - 1) + "&pageSize=6'"%>>
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
								href="ClientePagarCuotasSv?page=1&pageSize=6">1</a></li>
							<li class="page-item disabled"><span class="page-link">...</span>
							</li>
							<%
								}

								for (int i = startPage; i <= endPage; i++) {
							%>
							<li class="page-item <%=i == paginaActual ? "active" : ""%>"><a
								class="page-link"
								href="ClientePagarCuotasSv?page=<%=i%>&pageSize=5"> <%=i%>
							</a></li>
							<%
								}

								if (endPage < totalPaginas) {
							%>
							<li class="page-item disabled"><span class="page-link">...</span></li>
							<li class="page-item"><a class="page-link"
								href="ClientePagarCuotasSv?page=<%=totalPaginas%>&pageSize=6"><%=totalPaginas%></a></li>
							<%
								}
							%>
							<li
								class="page-item <%=paginaActual == totalPaginas ? "disabled" : ""%>">
								<a class="page-link"
								<%=paginaActual == totalPaginas ? ""
					: "href='ClientePagarCuotasSv?page=" + (paginaActual + 1) + "&pageSize=6'"%>>
									Siguiente </a>
							</li>
						</ul>
					</nav>

					<!-- Resumen y botón de pago -->
					<div class="bg-blue-light p-4 rounded">
						<div class="d-flex justify-content-between align-items-center">
							<div>
								<p class="mb-1">
									<strong>Total de cuotas seleccionadas:</strong> <span
										id="totalCuotasSeleccionadas">0</span>
								</p>
								<p class="mb-0">
									<strong>Monto total a pagar:</strong> $<span
										id="montoTotalPagar">0</span>
								</p>
							</div>
							<button type="submit" name="action" value="pagar" id="btnPagarCuotas" class="btn btn-primary">Pagar cuotas seleccionadas</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		const checkboxes = document.querySelectorAll('.cuota-checkbox');
		const totalCuotasSpan = document.getElementById('totalCuotasSeleccionadas');
		const montoTotalPagarSpan = document.getElementById('montoTotalPagar');
		const btnPagarCuotas = document.getElementById('btnPagarCuotas');
		const paginationLinks = document.querySelectorAll('.pagination .page-link');
		
		function updateTotals() {
		    let totalCuotas = 0;
		    let montoTotal = 0;
		    
		    checkboxes.forEach(checkbox => {
		        if (checkbox.checked) {
		            totalCuotas++;
		            
		            const row = checkbox.closest('tr');
		            
		            const montoString = row.querySelector('td:nth-child(2)').textContent.replace('$', '').trim();
		            const monto = parseFloat(montoString);
		            
		            montoTotal += monto;
		        }
		    });
		    totalCuotasSpan.textContent = totalCuotas;
		    montoTotalPagarSpan.textContent = montoTotal.toFixed(2);
		    
		    btnPagarCuotas.disabled = totalCuotas === 0;
		    
		    paginationLinks.forEach(link => {
		        if (totalCuotas > 0) {
		            link.classList.add('disabled-link');
		            link.style.pointerEvents = 'none';
		        } else {
		            link.classList.remove('disabled-link');
		            link.style.pointerEvents = '';
		        }
		    });
		}
		
		checkboxes.forEach(checkbox => {
		    checkbox.addEventListener('change', updateTotals);
		});
		
		updateTotals();

	    function showPaymentSuccessAlert() {
	        Swal.fire({
	            title: 'Éxito',
	            text: 'Pago realizado con éxito.',
	            icon: 'success',
	            confirmButtonText: 'OK'
	        });
	    }

	    function showInsufficientBalanceAlert() {
	        Swal.fire({
	            title: 'Error',
	            text: 'No tenés saldo suficiente.',
	            icon: 'error',
	            confirmButtonText: 'OK'
	        });
	    }

	    var saldoInsuficiente = <%= request.getAttribute("saldoInsuficiente") %>;
	    var pagoRealizado = <%= request.getAttribute("pagoRealizado") %>;
	
	    if (saldoInsuficiente) {
	        showInsufficientBalanceAlert();
	    } else if (pagoRealizado) {
	        showPaymentSuccessAlert();
	    }
		
	</script>


</body>
</html>
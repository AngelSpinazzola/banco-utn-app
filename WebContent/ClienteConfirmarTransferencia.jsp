<%@ page import="entidad.Cliente"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Confirmá la transferencia</title>
	<%@ include file="Componentes/Head.jsp"%>
	<style>
        .container {
        	height: 60vh;
        }
        .transfer-confirmation {
            max-width: 500px;
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .detail-list {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
    </style>
</head>
<body>
   <jsp:include page="Componentes/Navbar.jsp"></jsp:include>
   
   <div class="container d-flex flex-column justify-content-center align-items-center vh-100">
        <div class="transfer-confirmation text-center">
            <h2 class="mb-4 text-primary">Revisá si está todo bien</h2>
            <p class="lead mb-4">Detalles de la transferencia:</p>
            
            <div class="detail-list">
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <strong>Cuenta origen (CBU):</strong> 
                        <span class="text-muted"><%= request.getAttribute("cbuOrigen") %></span>
                    </li>
                    <li class="mb-2">
                        <strong>Cuenta destino (CBU):</strong> 
                        <span class="text-muted"><%= request.getAttribute("cbuDestino") %></span>
                    </li>
                    <li class="mb-2">
                        <strong>Vas a transferir</strong> 
                        <span class="text-success">$<%= request.getAttribute("monto") %></span>
                    </li>
                </ul>
            </div>
            
            <!-- Formulario para confirmar transferencia -->
	        <form action="ClienteConfirmarTransferenciaSv" method="post">
	            <input type="hidden" name="cbuOrigen" value="<%= request.getAttribute("cbuOrigen") %>">
	            <input type="hidden" name="cbuDestino" value="<%= request.getAttribute("cbuDestino") %>">
	            <input type="hidden" name="monto" value="<%= request.getAttribute("monto") %>">
	            
	            <button type="submit" class="btn btn-success btn-lg mb-3">Confirmar transferencia</button>
	        </form>

            <div class="d-grid">
                <a href="ClientePanelSv" class="btn btn-outline-primary btn-lg">
                    Cancelar
                </a>
            </div>
        </div>
    </div>
    
    <script>
    <% 
   	String successTransferencia = (String) request.getAttribute("successTransferencia");
   	if (successTransferencia != null && !successTransferencia.isEmpty()) { 
    %>
        Swal.fire({
            icon: 'success', 
            title: 'Éxito',
            text: '<%= successTransferencia %>',
            confirmButtonText: 'Aceptar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "ClientePanelSv"; 
            }
        });
    <% } %>

    <% 
    String errorTransferencia = (String) request.getAttribute("errorTransferencia");
    if (errorTransferencia != null && !errorTransferencia.isEmpty()) { 
    %>
        Swal.fire({
            icon: 'error', 
            title: 'Error',
            text: '<%= errorTransferencia %>',
            confirmButtonText: 'Aceptar'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "ClientePanelSv"; 
            }
        });
    <% } %>
	</script>
</body>
</html>
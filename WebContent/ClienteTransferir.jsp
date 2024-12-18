<%@ page import="entidad.Cliente" %>
<%@ page import="entidad.Cuenta" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        .transfer-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 0 20px;
        }

        .transfer-container h2 {
            text-align: center;
            margin-bottom: 10px;
            font-size: 24px;
        }

        .transfer-subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }

        .transfer-form {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px; 
        }

        .transfer-section {
            padding: 20px;
            position: relative;
        }

        .section-header {
            background-color: var(--navbar-bg-color);
            color: white;
            padding: 12px 20px;
            font-weight: 500;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        .section-content {
            padding: 20px;
            background-color: #f9f9f9;
            border-bottom-left-radius: 8px;
            border-bottom-right-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
        }

        .form-select, .form-input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            margin-bottom: 15px;
            box-sizing: border-box;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-size: 14px;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        .btn-volver {
            background-color: #e2e2e2;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            color: #333;
            width: 20%;
        }

        .btn-transferir {
            background-color: #198754;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            width: 70%;
        }

        .btn-transferir:hover {
            background-color: #157347;
        }
        .btn-volver:hover {
            background-color: #d0d0d0;
        }

        .no-accounts-message {
            text-align: center;
            padding: 50px 30px;
            border-radius: 10px;
            max-width: 500px;
            margin: 0 auto;
        }

        .no-accounts-message .icon-container {
            font-size: 60px;
            color: #ffa500;
            margin-bottom: 20px;
        }

        .no-accounts-message h3 {
            color: #333;
            margin-bottom: 15px;
        }

        .no-accounts-message p {
            color: #666;
            margin-bottom: 25px;
        }

        .actions-container {
            display: flex;
            justify-content: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <%@ include file="Componentes/Head.jsp" %>
    <jsp:include page="Componentes/Navbar.jsp"></jsp:include>

    <form action="ClienteTransferirSv" method="post">
            <% 
                ArrayList<Cuenta> listaCuentas = (ArrayList<Cuenta>) request.getAttribute("listaCuentas");
                if (listaCuentas == null || listaCuentas.isEmpty()) { 
            %>
            <div class="transfer-container" style="padding-top: 80px;">
                <div class="no-accounts-message">
                    <div class="icon-container">
                        <i class="fa fa-exclamation-circle"></i>
                    </div>
                    <h3>No tenés cuentas asociadas</h3>
                    <p>Para realizar transferencias, necesitas tener al menos una cuenta bancaria.</p>
                </div>
            </div>
            <% } else { %>
                <div class="transfer-container">
                    <h2>Transferir dinero</h2>
                    <p class="transfer-subtitle">Selecciona una cuenta de origen, ingresa el monto y realiza la transferencia</p>

                    <!-- Formulario de cuenta de origen -->
                    <div class="transfer-form">
                        <div class="section-header">Cuenta de origen</div>
                        <div class="section-content">
                            <label>Selecciona una cuenta</label>
                            <select class="form-select" name="cbuOrigen">
                                <% for (int i = 0; i < listaCuentas.size(); i++) {
                                    Cuenta cuenta = listaCuentas.get(i);
                                    String selected = (i == 0) ? "selected" : ""; %>
                                    <option value="<%= cuenta.getCbu() %>" <%= selected %>>
                                        N° Cuenta: <%= cuenta.getNumeroCuenta() %> - Saldo disponible: $<%= cuenta.getSaldo() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <!-- Formulario de cuenta de destino -->
                    <div class="transfer-form">
                        <div class="section-header">Cuenta de destino</div>
                        <div class="section-content">
                            <label>Ingresá el CBU</label>
                            <input type="text" class="form-input" placeholder="CBU" name="cbuDestino">

                            <label>Monto</label>
                            <input type="text" class="form-input" placeholder="$0.00" name="monto">

                            <div class="button-container">
                                <a href="ClientePanelSv" class="btn-secondary btn-volver">Volver</a>
                                <button type="submit" class="btn-primary btn-transferir">Transferir</button>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
    </form>

    <!-- Script para manejar los mensajes de SweetAlert -->
    <script>
        <% 
        String errorTransferencia = (String) request.getAttribute("errorTransferencia");
        if (errorTransferencia != null && !errorTransferencia.isEmpty()) { 
        %>
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: '<%= errorTransferencia %>',
                confirmButtonText: 'Aceptar'
            });
        <% } %>
    </script>
</body>
</html>

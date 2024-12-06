package servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Cuenta;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;

@WebServlet("/ClienteTransferirSv")
public class ClienteTransferirSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
    IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
	
    public ClienteTransferirSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		
		ArrayList<Cuenta> listaCuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		
		request.setAttribute("listaCuentas", listaCuentas);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteTransferir.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cbuOrigen = request.getParameter("cbuOrigen");
	    String cbuDestino = request.getParameter("cbuDestino");
	    String monto = request.getParameter("monto");


	    Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
	    Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
	    ArrayList<Cuenta> listaCuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());

	    request.setAttribute("listaCuentas", listaCuentas);

	    int resultado = iCuentaNegocio.validarTransferencia(cbuOrigen, cbuDestino, monto);
	    
	    // Establecer un atributo para el mensaje de error
	    switch(resultado) {
	        case -1:
	            request.setAttribute("errorTransferencia", "Los CBUs son iguales.");
	            break;
	        case -2:
	            request.setAttribute("errorTransferencia", "El monto no es válido.");
	            break;
	        case -3:
	            request.setAttribute("errorTransferencia", "No hay suficiente saldo para realizar la transferencia.");
	            break;
	        case -4:
	            request.setAttribute("errorTransferencia", "El CBU de destino no existe.");
	            break;
	    }

	    // Si la transferencia es válida, se realiza
	    if (resultado == 0) {
	    	request.setAttribute("cbuOrigen", cbuOrigen);
	        request.setAttribute("cbuDestino", cbuDestino);
	        request.setAttribute("monto", monto);
	        RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteConfirmarTransferencia.jsp");
	        dispatcher.forward(request, response);
	        return; 
	    }

	    RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteTransferir.jsp");
	    dispatcher.forward(request, response);
	}

}
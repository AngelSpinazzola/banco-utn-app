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
import entidad.TipoPrestamo;
import entidad.Usuario;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IPrestamoNegocio;
import negocio.ITipoPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;
import negocioImpl.TipoPrestamoNegocioImpl;

@WebServlet("/ClienteSolicitudPrestamoSv")
public class ClienteSolicitudPrestamoSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
    ITipoPrestamoNegocio iTipoPrestamoNegocio = new TipoPrestamoNegocioImpl();   
    ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
    IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
	
    public ClienteSolicitudPrestamoSv() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ArrayList<TipoPrestamo> listaTipoPrestamos = iTipoPrestamoNegocio.getTipoPrestamos();

		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		
		ArrayList<Cuenta> listaCuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		
		request.setAttribute("listaTipoPrestamos", listaTipoPrestamos);
		request.setAttribute("listaCuentas", listaCuentas);
		
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("ClienteSolicitarPrestamo.jsp");
        dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String monto = request.getParameter("monto");
		String idTipoPrestamo = request.getParameter("idTipoPrestamo");
		String plazo = request.getParameter("plazo");
		String idCuenta = request.getParameter("idCuenta");
		
		int resultado = iPrestamoNegocio.validarMonto(monto);
		manejarErroresMonto(resultado, request); 
		
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		
		ArrayList<Cuenta> listaCuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		ArrayList<TipoPrestamo> listaTipoPrestamos = iTipoPrestamoNegocio.getTipoPrestamos();
		
		request.setAttribute("montoIngresado", monto);
		request.setAttribute("plazoSeleccionado", plazo);
		request.setAttribute("listaCuentas", listaCuentas);
		request.setAttribute("listaTipoPrestamos", listaTipoPrestamos);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteSolicitarPrestamo.jsp");
        dispatcher.forward(request, response);
	}
	
	private void manejarErroresMonto(int resultado, HttpServletRequest request) {
	    switch (resultado) {
	        case -1:
	            request.setAttribute("errorMonto", "El monto no puede estar vacío.");
	            break;
	        case -2:
	            request.setAttribute("errorMonto", "El monto no puede ser negativo.");
	            break;
	        case -3:
	            request.setAttribute("errorMonto", "El monto no puede ser 0.");
	            break;
	        case -4:
	            request.setAttribute("errorMonto", "El monto no puede tener letras.");
	            break;
	        case -5:
	            request.setAttribute("errorMonto", "El monto no puede tener letras ni símbolos no permitidos.");
	            break;
	        case -6:
	            request.setAttribute("errorMonto", "El monto no puede tener más de un punto decimal.");
	            break;
	    }
	}

	
	

}

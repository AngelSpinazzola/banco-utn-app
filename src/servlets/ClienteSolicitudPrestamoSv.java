package servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Cliente;
import entidad.Cuenta;
import entidad.Prestamo;
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

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
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
		
		Usuario usuario = (Usuario) request.getSession().getAttribute("usuario");
		Cliente cliente = iClienteNegocio.getClientePorIdUsuario(usuario.getId());
		ArrayList<Cuenta> listaCuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		ArrayList<TipoPrestamo> listaTipoPrestamos = iTipoPrestamoNegocio.getTipoPrestamos();
		
		request.setAttribute("montoIngresado", monto);
		request.setAttribute("plazoSeleccionado", plazo);
		request.setAttribute("listaCuentas", listaCuentas);
		request.setAttribute("listaTipoPrestamos", listaTipoPrestamos);
		
		if (listaCuentas == null || listaCuentas.isEmpty()) {
			request.setAttribute("errorPrestamo", "No tenes cuentas para solicitar un préstamo.");
			
			RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteSolicitarPrestamo.jsp");
	        dispatcher.forward(request, response);
	        return;
	    }
		
		TipoPrestamo tipoPrestamo = new TipoPrestamo();
		tipoPrestamo.setIdTipoPrestamo(Integer.parseInt(idTipoPrestamo));
		Prestamo prestamo = new Prestamo();		
		prestamo.setTipoPrestamo(tipoPrestamo);
		BigDecimal montoPedido = new BigDecimal(monto);
		prestamo.setMontoPedido(montoPedido);
		prestamo.setCuotas(Integer.parseInt(plazo));
		Date fecha = new java.sql.Date(new java.util.Date().getTime());
		prestamo.setFecha(fecha);
		
		boolean resultado = iPrestamoNegocio.solicitarPrestamo(prestamo, Integer.parseInt(idCuenta)); 
		if(resultado) {
			request.setAttribute("successPrestamo", "Prestamo solicitado");
			RequestDispatcher dispatcher = request.getRequestDispatcher("/ClienteSolicitarPrestamo.jsp");
	        dispatcher.forward(request, response);
		}
	}
}

package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Cuenta;
import entidad.TipoCuenta;
import excepciones.PrestamoNegocioException;
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IPrestamoNegocio;
import negocio.ITipoCuentaNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;
import negocioImpl.TipoCuentaNegocioImpl;

@WebServlet("/AdminCuentasClienteSv")
public class AdminCuentasClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
	private ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
	private ITipoCuentaNegocio iTipoCuentaNegocio = new TipoCuentaNegocioImpl();
	
	public AdminCuentasClienteSv() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Cliente cliente = iClienteNegocio.getDetalleCliente(Integer.parseInt(request.getParameter("idCliente")));

		ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		ArrayList<TipoCuenta> listaTipoCuentas = iTipoCuentaNegocio.getTipoCuentas();
		
		int totalPrestamos = iPrestamoNegocio.getTotalPrestamosCount(cliente.getIdCliente());
		
		request.setAttribute("cliente", cliente);
		request.setAttribute("totalPrestamos", totalPrestamos);
		request.setAttribute("cuentas", cuentas);
		request.setAttribute("listaTipoCuentas", listaTipoCuentas);

		RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminCuentasCliente.jsp");
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		try {
			if ("modificarSaldo".equals(action)) {
				modificarSaldo(request, response);
			} else if ("eliminarCuenta".equals(action)) {
				eliminarCuenta(request, response);
			}
			else if("agregarCuenta".equals(action)) {
				agregarCuenta(request, response);
			}
		} catch (PrestamoNegocioException e) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,"Error al procesar la solicitud: " + e.getMessage());
		}

	}
	
	private void agregarCuenta(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String idClienteStr = request.getParameter("idCliente");
		String idTipoCuentaStr = request.getParameter("idTipoCuenta");
		
		System.out.println("idTipo en String: " + idTipoCuentaStr);
		System.out.println("idCliente en String: " + idClienteStr);
		
		int idCliente = Integer.parseInt(idClienteStr);
		int idTipoCuenta = Integer.parseInt(idTipoCuentaStr);
		
		System.out.println("idTipo : " + idTipoCuenta);
		System.out.println("idCliente : " + idCliente);
		
		int resultado = iCuentaNegocio.agregarCuenta(idCliente, idTipoCuenta);
		
		response.sendRedirect("AdminCuentasClienteSv?idCliente=" + idCliente + "&resultadoCreacion=" + resultado);
	
	}

	private void modificarSaldo(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int idCuenta = Integer.parseInt(request.getParameter("idCuenta"));
		int idCliente = Integer.parseInt(request.getParameter("idCliente"));
		BigDecimal nuevoSaldo = new BigDecimal(request.getParameter("nuevoSaldo"));

		iCuentaNegocio.modificarSaldo(idCuenta, nuevoSaldo);

		response.sendRedirect("AdminCuentasClienteSv?idCliente=" + idCliente);
	}

	private void eliminarCuenta(HttpServletRequest request, HttpServletResponse response) throws IOException {
		int idCuenta = Integer.parseInt(request.getParameter("idCuenta"));
		int idCliente = Integer.parseInt(request.getParameter("idCliente"));

		int cuentaEliminada = iCuentaNegocio.eliminarCuenta(idCuenta);

		response.sendRedirect("AdminCuentasClienteSv?idCliente=" + idCliente + "&resultado=" + cuentaEliminada);
	}

}
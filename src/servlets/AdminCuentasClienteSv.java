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
import negocio.IClienteNegocio;
import negocio.ICuentaNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.CuentaNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;


@WebServlet("/AdminCuentasClienteSv")
public class AdminCuentasClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
	private ICuentaNegocio iCuentaNegocio = new CuentaNegocioImpl();
       

    public AdminCuentasClienteSv() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Cliente cliente = iClienteNegocio.getDetalleCliente(Integer.parseInt(request.getParameter("idCliente")));
		
		ArrayList<Cuenta> cuentas = iCuentaNegocio.getCuentasDelCliente(cliente.getIdCliente());
		
		int totalPrestamos = iPrestamoNegocio.getTotalPrestamosCount(cliente.getIdCliente());
		
		request.setAttribute("cliente", cliente);
		request.setAttribute("totalPrestamos", totalPrestamos);
		request.setAttribute("cuentas", cuentas);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminCuentasCliente.jsp");
	    dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		System.out.println("ACCION RECIBIDA EN EL DOPOST:" + action);

        try {
            if ("modificarSaldo".equals(action)) {
                modificarSaldo(request, response);
            } else if ("eliminarCuenta".equals(action)) {
                eliminarCuenta(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Acción no reconocida");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud: " + e.getMessage());
        }

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
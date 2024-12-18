package servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.Year;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.DatosDashboard;
import negocio.IClienteNegocio;
import negocio.IMovimientoNegocio;
import negocio.IPrestamoNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.MovimientoNegocioImpl;
import negocioImpl.PrestamoNegocioImpl;


@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    IMovimientoNegocio iMovimientoNegocio = new MovimientoNegocioImpl(); 
    IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();
    IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
    
    public DashboardServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        BigDecimal totalOtorgadoEnPrestamos = BigDecimal.ZERO;
        int totalClientes = iClienteNegocio.getTotalClientesCount();
        
        totalOtorgadoEnPrestamos = iPrestamoNegocio.totalOtorgadoEnPrestamos();
        
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("totalOtorgadoEnPrestamos", totalOtorgadoEnPrestamos);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminPanel.jsp");
	    dispatcher.forward(request, response);
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

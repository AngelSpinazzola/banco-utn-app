package servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Prestamo;
import negocio.IPrestamoNegocio;
import negocioImpl.PrestamoNegocioImpl;


@WebServlet("/AdminSolicitudesPrestamosSv")
public class AdminSolicitudesPrestamosSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();

    public AdminSolicitudesPrestamosSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 5;
		
        ArrayList<Prestamo> listaPrestamos = iPrestamoNegocio.getSolicitudesDePrestamos(page, pageSize);

        int totalPrestamos = iPrestamoNegocio.getTotalSolicitudesPrestamosCount();
        int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);

        request.setAttribute("totalPrestamos", totalPrestamos);
	    request.setAttribute("totalPaginas", totalPaginas);
	    request.setAttribute("listaPrestamos", listaPrestamos);
	    request.setAttribute("paginaActual", page);

	    RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminPrestamosRevision.jsp");
	    dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        int idPrestamo = Integer.parseInt(request.getParameter("idPrestamo"));
        boolean resultado;
        
        if ("aprobar".equals(accion)) {
             resultado = iPrestamoNegocio.aprobarPrestamo(idPrestamo);
             if(resultado) {
            	 request.setAttribute("prestamoAprobado", "Préstamo aprobado correctamente");
             }
        } 
        else if ("rechazar".equals(accion)) {
        	resultado = iPrestamoNegocio.rechazarPrestamo(idPrestamo);
            if(resultado) {
            	request.setAttribute("prestamoRechazado", "Préstamo rechazado correctamente.");
            }
        }
        
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 5;
		
        ArrayList<Prestamo> listaPrestamos = iPrestamoNegocio.getSolicitudesDePrestamos(page, pageSize);

        int totalPrestamos = iPrestamoNegocio.getTotalSolicitudesPrestamosCount();
        int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);

        request.setAttribute("totalPrestamos", totalPrestamos);
	    request.setAttribute("totalPaginas", totalPaginas);
	    request.setAttribute("listaPrestamos", listaPrestamos);
	    request.setAttribute("paginaActual", page);
	    
        RequestDispatcher dispatcher = request.getRequestDispatcher("/AdminPrestamosRevision.jsp");
        dispatcher.forward(request, response);
	}

}

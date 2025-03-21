package servlets;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Prestamo;
import negocio.IPrestamoNegocio;
import negocioImpl.PrestamoNegocioImpl;

@WebServlet("/AdminPrestamosSv")
public class AdminPrestamosSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();   
	
    public AdminPrestamosSv() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 5;

        ArrayList<Prestamo> listaPrestamos = iPrestamoNegocio.getPrestamos(page, pageSize);

        int totalPrestamos = iPrestamoNegocio.getTotalPrestamosCount();
        int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);

        request.setAttribute("prestamos", listaPrestamos);
        request.setAttribute("totalPrestamos", totalPrestamos);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("paginaActual", page);

        request.getRequestDispatcher("/AdminPrestamos.jsp").forward(request, response);
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

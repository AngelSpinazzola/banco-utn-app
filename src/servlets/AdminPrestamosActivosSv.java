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

@WebServlet("/AdminPrestamosActivosSv")
public class AdminPrestamosActivosSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IPrestamoNegocio iPrestamoNegocio = new PrestamoNegocioImpl();   
	
    public AdminPrestamosActivosSv() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 5;

        // Obtener los préstamos activos según la página y el tamaño de página
        ArrayList<Prestamo> listaPrestamos = iPrestamoNegocio.getPrestamosActivos(page, pageSize);

        // Calcular el total de préstamos activos
        int totalPrestamos = iPrestamoNegocio.getTotalPrestamosActivosCount();

        // Calcular el número total de páginas
        int totalPaginas = (int) Math.ceil((double) totalPrestamos / pageSize);

        // Configurar los atributos en el request
        request.setAttribute("prestamosActivos", listaPrestamos);
        request.setAttribute("totalPrestamos", totalPrestamos);
        request.setAttribute("totalPaginas", totalPaginas);
        request.setAttribute("paginaActual", page);

        // Redirigir al JSP correspondiente
        request.getRequestDispatcher("/AdminPrestamosActivos.jsp").forward(request, response);
    }


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}

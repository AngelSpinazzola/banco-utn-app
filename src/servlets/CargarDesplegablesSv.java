package servlets;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Provincia;
import negocio.INacionalidadNegocio;
import negocioImpl.LocalidadNegocioImpl;
import negocioImpl.NacionalidadNegocioImpl;
import negocioImpl.ProvinciaNegocioImpl;

@WebServlet("/CargarDesplegablesSv")
public class CargarDesplegablesSv extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public CargarDesplegablesSv() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		ProvinciaNegocioImpl provinciaNegocioImpl = new ProvinciaNegocioImpl();
		LocalidadNegocioImpl localidadNegocioImpl = new LocalidadNegocioImpl();
		INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();

		ArrayList<Provincia> listaProvincias = provinciaNegocioImpl.listarProvincias();
		ArrayList<Localidad> listaLocalidades = localidadNegocioImpl.listarLocalidades();
		ArrayList<Nacionalidad> listaNacionalidades = iNacionalidadNegocio.listarNacionalidades();
		
		request.setAttribute("listaProvincias", listaProvincias);
        request.setAttribute("listaLocalidades", listaLocalidades);
        request.setAttribute("listaNacionalidades", listaNacionalidades);
        
        if ("agregarCliente".equals(action)) {
        	request.getRequestDispatcher("AdminAltaCliente.jsp").forward(request, response);
        }
        else {
            request.getRequestDispatcher("Error.jsp").forward(request, response);        	
        }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}
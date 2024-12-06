package servlets;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import entidad.Cliente;
import entidad.Direccion;
import entidad.Localidad;
import entidad.Nacionalidad;
import entidad.Provincia;
import negocio.IClienteNegocio;
import negocio.ILocalidadNegocio;
import negocio.INacionalidadNegocio;
import negocio.IProvinciaNegocio;
import negocioImpl.ClienteNegocioImpl;
import negocioImpl.LocalidadNegocioImpl;
import negocioImpl.NacionalidadNegocioImpl;
import negocioImpl.ProvinciaNegocioImpl;

@WebServlet("/AltaClienteSv")
public class AltaClienteSv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	INacionalidadNegocio iNacionalidadNegocio = new NacionalidadNegocioImpl();
	IProvinciaNegocio iProvinciaNegocio = new ProvinciaNegocioImpl();
	ILocalidadNegocio iLocalidadNegocio = new LocalidadNegocioImpl();
	IClienteNegocio iClienteNegocio = new ClienteNegocioImpl();
	
    public AltaClienteSv() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
		
        String nombreUsuario = request.getParameter("nombreUsuario");
        String pass = request.getParameter("password");
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String dni = request.getParameter("dni");
        String cuil = request.getParameter("cuil");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String sexo = request.getParameter("sexo");
        String telefono = request.getParameter("telefono");
        String idNacionalidad = request.getParameter("nacionalidad");
        String email = request.getParameter("email");
        String idLocalidad = request.getParameter("localidad");
        String idProvincia = request.getParameter("provincia"); 
        String codigoPostal = request.getParameter("codigoPostal");
        String calle = request.getParameter("calle");
        String numero = request.getParameter("numero");
        
        Cliente nuevoCliente = new Cliente();
        Direccion nuevaDireccion = new Direccion(); 
        
        nuevoCliente.setNombre(nombre);
        nuevoCliente.setApellido(apellido);
        nuevoCliente.setDni(dni);
        nuevoCliente.setCuil(cuil);
        nuevoCliente.setSexo(sexo);
        nuevoCliente.setNumeroTelefono(telefono);
        nuevoCliente.setNombreUsuario(nombreUsuario);
        nuevoCliente.setEmail(email);
        nuevoCliente.setPassword(pass);
        nuevoCliente.setFechaNacimiento(Date.valueOf(fechaNacimiento));

        Nacionalidad nacionalidad = iNacionalidadNegocio.obtenerNacionalidadPorId(Integer.parseInt(idNacionalidad));
        nuevoCliente.setNacionalidad(nacionalidad);
        
        
        Provincia provincia = iProvinciaNegocio.obtenerProvinciaPorId(Integer.parseInt(idProvincia));
        Localidad localidad = iLocalidadNegocio.obtenerLocalidadPorId(Integer.parseInt(idLocalidad));
        nuevaDireccion.setCodigoPostal(codigoPostal);
        nuevaDireccion.setCalle(calle);
        nuevaDireccion.setNumero(numero);
        nuevaDireccion.setLocalidad(localidad); 
        nuevaDireccion.setProvincia(provincia);
        
        nuevoCliente.setDireccion(nuevaDireccion);        
        iClienteNegocio.agregarCliente(nuevoCliente);
        response.sendRedirect("ListarClientesSv");   
	}
}
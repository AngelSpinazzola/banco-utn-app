package negocio;

import java.util.ArrayList;
import entidad.Nacionalidad;

public interface INacionalidadNegocio {
	ArrayList<Nacionalidad> listarNacionalidades();
	public Nacionalidad obtenerNacionalidadPorId(int id);
}
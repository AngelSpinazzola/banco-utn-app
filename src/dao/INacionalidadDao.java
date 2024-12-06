package dao;

import java.util.ArrayList;
import entidad.Nacionalidad;

public interface INacionalidadDao {
	public ArrayList<Nacionalidad> listarNacionalidades();
	public Nacionalidad obtenerNacionalidadPorId(int id);
}
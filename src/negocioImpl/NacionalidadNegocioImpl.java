package negocioImpl;

import java.util.ArrayList;
import dao.INacionalidadDao;
import daoImpl.NacionalidadDaoImpl;
import entidad.Nacionalidad;
import negocio.INacionalidadNegocio;

public class NacionalidadNegocioImpl implements INacionalidadNegocio {
	private INacionalidadDao iNacionalidadDao;

	public NacionalidadNegocioImpl() {
		this.iNacionalidadDao = new NacionalidadDaoImpl();
	}

	@Override
	public ArrayList<Nacionalidad> listarNacionalidades() {
		ArrayList<Nacionalidad> listaNacionalidades = iNacionalidadDao.listarNacionalidades();
		return listaNacionalidades;
	}

	@Override
	public Nacionalidad obtenerNacionalidadPorId(int id) {
		Nacionalidad nacionalidad = iNacionalidadDao.obtenerNacionalidadPorId(id);
		return nacionalidad;
	}
}
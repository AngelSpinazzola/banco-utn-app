package negocioImpl;

import java.util.ArrayList;
import dao.ITipoPrestamoDao;
import daoImpl.TipoPrestamoDaoImpl;
import entidad.TipoPrestamo;
import negocio.ITipoPrestamoNegocio;

public class TipoPrestamoNegocioImpl implements ITipoPrestamoNegocio{
	ITipoPrestamoDao iTipoPrestamoDao = new TipoPrestamoDaoImpl();
	
	@Override
	public ArrayList<TipoPrestamo> getTipoPrestamos(){
		ArrayList<TipoPrestamo> listaTipoPrestamos = iTipoPrestamoDao.getTipoPrestamos();
		
		return listaTipoPrestamos;
	}
}

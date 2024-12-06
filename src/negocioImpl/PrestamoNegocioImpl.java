package negocioImpl;

import java.util.ArrayList;
import dao.IPrestamoDao;
import daoImpl.PrestamoDaoImpl;
import entidad.Prestamo;
import negocio.IPrestamoNegocio;

public class PrestamoNegocioImpl implements IPrestamoNegocio{
	IPrestamoDao iPrestamoDao = new PrestamoDaoImpl();
	
	@Override
	public ArrayList<Prestamo> getPrestamosPorCliente(int idCliente, int page, int pageSize) {
		ArrayList<Prestamo> prestamos = iPrestamoDao.getPrestamosPorCliente(idCliente , page, pageSize);
		
		return prestamos;
	}
	
	@Override
	public int getTotalPrestamosCount(int idCliente) {
	    return iPrestamoDao.getTotalPrestamosCount(idCliente); 
	}
	
	@Override
	public int calcularTotalPaginas(int idCliente, int pageSize) {
	    int totalPrestamos = getTotalPrestamosCount(idCliente); 
	    return (int) Math.ceil((double) totalPrestamos / pageSize);
	}

}